@php
    $companyCopyright = trim((string) ($footerCopyright ?? '')) ?: '© 江西格兰碧科技技术有限公司 版权所有';
    $companyFiling = trim((string) ($footerFilingInfo ?? ''));
    $companyFilingUrl = trim((string) ($footerFilingUrl ?? ''));
@endphp
<div class="gf-company-footer space-y-2 text-sm leading-6">
    <p>
        电话：<a href="tel:+8615979004534">15979004534</a>
        <span aria-hidden="true">　</span>
        邮箱：<a href="mailto:847120085@qq.com">847120085@qq.com</a>
    </p>
    <p>地址：江西省萍乡市萍乡经济技术开发区市府西路623号金融综合体3号楼，中国（萍乡）跨境电子商务综合试验区2楼2015</p>
    <p>
        {{ $companyCopyright }}
        @if ($companyFiling !== '')
            <span aria-hidden="true">｜</span>
            @if ($companyFilingUrl !== '')
                <a href="{{ $companyFilingUrl }}" target="_blank" rel="nofollow noopener noreferrer">{{ $companyFiling }}</a>
            @else
                <span>{{ $companyFiling }}</span>
            @endif
        @endif
    </p>
</div>
