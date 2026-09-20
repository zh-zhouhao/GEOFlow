#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

read -r -s -p "请输入新的管理员密码: " NEW_ADMIN_PASSWORD
echo
read -r -s -p "再次输入新的管理员密码: " NEW_ADMIN_PASSWORD_CONFIRM
echo

if [ "$NEW_ADMIN_PASSWORD" != "$NEW_ADMIN_PASSWORD_CONFIRM" ]; then
    echo "两次密码不一致" >&2
    unset NEW_ADMIN_PASSWORD NEW_ADMIN_PASSWORD_CONFIRM
    exit 1
fi

if [ "${#NEW_ADMIN_PASSWORD}" -lt 12 ]; then
    echo "密码至少需要 12 个字符" >&2
    unset NEW_ADMIN_PASSWORD NEW_ADMIN_PASSWORD_CONFIRM
    exit 1
fi

result="$({
  docker compose \
    --env-file .env.prod \
    -f docker-compose.prod.yml \
    exec -T \
    -e NEW_ADMIN_PASSWORD="$NEW_ADMIN_PASSWORD" \
    app \
    php artisan tinker \
    --execute='
      $user = \App\Models\Admin::where("username", "admin")->first();
      if (! $user) {
          fwrite(STDERR, "管理员账号不存在\\n");
          exit(1);
      }
      // Admin.password uses Laravel hashed cast; assign plaintext and let the cast hash it.
      $user->password = getenv("NEW_ADMIN_PASSWORD");
      $user->save();
      echo "RESET_OK\\n";
    '
} 2>&1)"

if ! printf '%s\n' "$result" | grep -q 'RESET_OK'; then
    printf '%s\n' "$result" >&2
    echo "管理员密码重置失败" >&2
    unset NEW_ADMIN_PASSWORD NEW_ADMIN_PASSWORD_CONFIRM
    exit 1
fi

unset NEW_ADMIN_PASSWORD NEW_ADMIN_PASSWORD_CONFIRM
printf '%s\n' "管理员密码重置完成"
