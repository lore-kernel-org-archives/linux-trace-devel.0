Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4577C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 May 2022 21:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346581AbiEPVYx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 16 May 2022 17:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346446AbiEPVYw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 16 May 2022 17:24:52 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6035E377D0
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 May 2022 14:24:51 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id i19so31028704eja.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 May 2022 14:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=mSGnxzvPo04KbWMWZlDup6ysycmx7gLvsd7OeuJBIBw=;
        b=dH85q9WLX0VfJRBTcmSTkN/MNJ99u1mZW8je76hBo40e3mEjtqkO3tOyztCLkiX73Z
         TlWgHlLAPZ+h4LGMfTYf465a3Gq906Nt1uSs7/TZhBlkY8dy3fUaXBI6JrWdhVCYR5Bb
         403U2rNJc2fbOW3jyrXzuRjlEEslxK+7N/rLFU5T/ngZWNT4TBn6UokZCXcu6XZ4+0Lv
         sGMVrXUzScht5eztH9fHxzTC37ldLmL7L9u6RdmiXj49+BrEMS5XeEAtKLcAhpJSjvC/
         hJdCzp/evdst1ENbxGW2QfbndWUDwBnjYeJSrMxArsnVKlpTq97fENdhInun62eX1Ec5
         lkDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=mSGnxzvPo04KbWMWZlDup6ysycmx7gLvsd7OeuJBIBw=;
        b=IuHSiHaQEY8YPAjrdq9E8GXZ2pNuo8XT0c+MyxoL5NIQlBb39iCgtRHyEokzousF+f
         s69Z81Fgmmm0oSuQivJUfyQXHcydzKQhTxEe6w9KxUrc7j2MetvrL0/MFiDgcma+n9Ol
         9wqlokmaRYdFrzrriqVpUdE2MN1+/V0y28VBWy1AZfDETJ2BUb/01Elfps4ZtJ5P9BYI
         To0L8lX+CmPeZTP9wUXr/lhxLVjK4kBgKHKJNEACQIBOkTw3BgdUVDcILoGEbuavZCE9
         ckWvuvcUSz6jiyVdH+V6hm+NqdPp81mDFjjD9Jzq43BX/qpk3whyLddGbzK08AeFJB4Z
         OFeA==
X-Gm-Message-State: AOAM530PM4v5EyizqUr2sKeza37pS5nigu/ZgwUgd8SZBf7QjjXodyU0
        fEd9dQkx3Fp7chz1+dBDRhA=
X-Google-Smtp-Source: ABdhPJx3RgOWrwqteLMj8mdXicT2E8J+DBavPI6Rj25k0r//fqhYaVcL7gLL2EAXwEgyL3qIRj39Mw==
X-Received: by 2002:a17:907:1b0c:b0:6fe:25bf:b3e5 with SMTP id mp12-20020a1709071b0c00b006fe25bfb3e5mr9156496ejc.689.1652736289833;
        Mon, 16 May 2022 14:24:49 -0700 (PDT)
Received: from [192.168.3.2] (p5dd1ed70.dip0.t-ipconnect.de. [93.209.237.112])
        by smtp.googlemail.com with ESMTPSA id p13-20020aa7cc8d000000b0042aa23fa93bsm3701608edt.20.2022.05.16.14.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 14:24:49 -0700 (PDT)
Message-ID: <6d8a8664837f2cdcc861e458274b27135685716a.camel@gmail.com>
Subject: Re: how to register an event handler for the instance
From:   christopher lee <christopher.lee.eu@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Mon, 16 May 2022 23:24:48 +0200
In-Reply-To: <20220516141427.775cd70a@gandalf.local.home>
References: <93fd065420c6a04141b5e8ba9c89dae1e7c9b6a0.camel@gmail.com>
         <CAPpZLN4A8tes3tnzDqLFBT7S2SvBixFwDW7GkYbSPeA+3e1yCQ@mail.gmail.com>
         <fbb8049e2a9fcce07110d5d97f08458d27c977b4.camel@gmail.com>
         <20220516141427.775cd70a@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

SGkgU3RldmVuLCAKCj5PbiBNb24sIDIwMjItMDUtMTYgYXQgMTQ6MTQgLTA0MDAsIFN0ZXZlbiBS
b3N0ZWR0IHdyb3RlOgo+IAo+IAo+IEFyZSB5b3Ugb25seSBsb29raW5nIHRvIHJlYWRpbmcgc29t
ZSBldmVudHMgb3IgYWxsIG9mIHRoZW0/CgpJIGNyZWF0ZWQgc2V2ZXJhbCBpbnN0YW5jZXMgYW5k
IG9ubHkgZW5hYmxlZCBvbmUgdHJhY2UgZXZlbnQgaW4gZWFjaAppbnN0YW5jZS4gSSBuZWVkIHRv
IHJlYWQgYWxsIHRyYWNlIGRhdGEgZnJvbSBlYWNoIHRyYWNlX3BpcGUgaW4gZWFjaAppbnN0YW5j
ZSBhbmQgcGFyc2UgdGhlIHRyYWNlIGluZm9ybWF0aW9uIGluIGVhY2ggaW5zdGFuY2UncyBhc3Nv
Y2lhdGVkCnRocmVhZC4gSSBmb3VuZCB0aGF0IGlmIEkgcmVhZCB0YWNlX3BpcGUsIHRoZW4gcGFy
c2Ugc3RyaW5nLCBpdCB3aWxsCm5vdCBjb25zdW1lIHNvIG11Y2ggQ1BVIHJlc291cmNlLgoKPiAK
PiA+IHRoaXMgZmlsZSwgdGhlIGhhbmRsZXIgd291bGQgbm90IGJlIGFibGUgdG8gZ2V0IHRyYWNl
IGluZm9ybWF0aW9uLgo+ID4gQmVjdWFzZSBpZiBJIHJlYWQgdGhpcyBmaWxlLCBhbmQgYWxzbyBj
YWxsIHRlcF9wcmludF9ldmVudCgpIHdpbGwKPiA+IGNvbnN1bWUgbG90cyBvZiBDUFUgcmVzb3J1
Y2UuIGhvdyBjYW4gSSBwYXJzZSB0aGUgdHJhY2UgZXZlbnQgaW5mbwo+ID4gd2l0aG91dCByZWFk
aW5nIHRoaXMgZmlsZT8KPiAKPiBUaGUgdGVwX3ByaW50X2V2ZW50KCkgaXMgZWFzaWVyIHRvIHVz
ZSwgYnV0IHlvdSBjYW4gZG8gdGhpbmdzCj4gbWFudWFsbHkgYXMKPiB3ZWxsLiBJJ2xsIG5lZWQg
dG8gd3JpdGUgYSB0dXRvcmlhbCB0byBleHBsYWluIHRoaXMgbW9yZSwgYnV0IEkgY2FuCj4gaGVs
cAo+IHlvdSBoZXJlLgo+IAoKVGhhbmtzIHNvIG11Y2ggZm9yIHlvdXIgc3VwcG9ydCEhCgo+ID4g
wqAKPiA+IAo+ID4gwqDCoMKgwqDCoMKgwqAgZm9yIChpID0gMDsgOyBpKyspCj4gPiB7wqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBj
aGFyCj4gPiAqcmF3X2J1ZjvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgCj4gPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgY2hhcgo+ID4gKmNwdTvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIAo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IGFzcHJpbnRmKCZjcHUsICIlcy9jcHUlZCIsIHBl
cl9jcHUsCj4gPiBpKTvCoMKgwqDCoMKgwqDCoMKgIAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGlmIChyZXQgPAo+ID4gMCnCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIAo+ID4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwZGllKCJDb3Vs
ZCBub3QgYWxsb2NhdGUgbWVtb3J5IGZvciBjcHUKPiA+IGJ1ZmZlcgo+ID4gJWQgbmFtZSIsIGkp
O8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IHN0
YXQoY3B1LAo+ID4gJnN0KTvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGlmIChyZXQgPCAwIHx8ICFTX0lTRElSKHN0LnN0X21vZGUpKQo+ID4ge8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAKPiA+IGZyZWUoY3B1KTvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIAo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvCj4gPiBzdGFydDvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoAo+ID4gfcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIAo+ID4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0ID0gYXNwcmludGYoJnJhd19idWYsICIlcy90cmFjZV9waXBlX3JhdyIsCj4gPiBjcHUpO8Kg
wqAgCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHJldCA8Cj4gPiAwKcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHBkaWUoIkNvdWxkIG5vdCBhbGxvY2F0ZSBtZW1vcnkgZm9yIGNw
dSAlZAo+ID4gcmF3Cj4gPiBidWZmZXIgbmFtZSIsIGkpO8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAKPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCByZWFkX3Jhd19idWZmZXIoaSwKPiA+IHJhd19idWYpO8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIAo+IAo+IFRoaXMgeW91
ciBvd24gY29kZT8KPiAKCm5vLCBpdCBpcyB5b3VyIGNvZGUsIGZyb20geW91ciBleGFtcGxlLgoK
Cj4gVGhlcmUgaXMgYSB3YXkgdG8gcmVhZCBpdCB5b3Vyc2VsZiBhbmQgdG8gcGljayBhbmQgY2hv
b3NlIHRoZSBldmVucwo+IHlvdQo+IHdhbnQuCj4gCj4gSWYgeW91IHJlYWQgdGhlIHJhdyBkYXRh
LCB5b3UnbGwgbmVlZCB0byByZWFkIGl0IGluIHBhZ2Ugc2l6ZSAoZm91bmQKPiBpbiB0aGUKPiBo
ZWFkZXIgdGVwIGZpbGUpIHRlcF9nZXRfcGFnZV9zaXplKCkuIEFuZCByZWFkIG9uZSBwYWdlIGF0
IGEgdGltZS4KPiBUaGVuIHlvdQo+IGNhbiB1c2UgdGhlIGtidWZmZXIgY29kZSAoYWx0aG91Z2gg
SSBoYXZlbid0IGZpbmlzaGVkIHRoZSBtYW4gcGFnZXMKPiBmb3IKPiB0aGVtKQo+IAo+IExvb2sg
YXQgdGhlIHRyYWNlZXZlbnQva2J1ZmZlci5oIGZpbGUgc3VwcGxpZWQgYnkgbGlidHJhY2VldmVu
dC4KPiAKPiBZb3UgY2FuIGRvIHNvbWV0aGluZyBsaWtlIHRoZSBmb2xsb3dpbmc6Cj4gCj4gwqDC
oMKgwqDCoMKgwqDCoHVuc2lnbmVkIGxvbmcgbG9uZyB0czsgLy8gdGltZSBzdGFtcCBvZiBldmVu
dAo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgdGVwX3JlY29yZCByZWNvcmQ7IC8vIHNob3VsZCBw
cm9iYWJseSBiZSBhbGxvY2F0ZWQKPiAKPiDCoMKgwqDCoMKgwqDCoMKgLyogRm9yIGxpdHRsZSBl
bmRpYW4gNjQgYml0IG1hY2hpbmVzICovCj4gwqDCoMKgwqDCoMKgwqDCoGtidWYgPSBrYnVmZmVy
X2FsbG9jKEtCVUZGRVJfTFNJWkVfOCwgS0JVRkZFUl9FTkRJQU5fTElUVExFKTsKPiAKPiDCoMKg
wqDCoMKgwqDCoMKgcmVhZChmZCwgYnVmLCBwYWdlX3NpemUpOwo+IAo+IMKgwqDCoMKgwqDCoMKg
wqBrYnVmZmVyX2xvYWRfc3ViYnVmZmVyKGtidWYsIGJ1Zik7Cj4gCj4gwqDCoMKgwqDCoMKgwqDC
oGRhdGEgPSBrYnVmZmVyX3JlYWRfZXZlbnQoa2J1ZiwgJnRzKTsKPiAKPiDCoMKgwqDCoMKgwqDC
oMKgaWYgKCFkYXRhKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuOyAv
LyBlbmQgb2Ygc3ViIGJ1ZmZlci4KPiAKPiDCoMKgwqDCoMKgwqDCoMKgLyogTW92ZSB0aGUga2J1
ZiBjdXJzb3IgdG8gdGhlIG5leHQgZXZlbnQgKi8KPiDCoMKgwqDCoMKgwqDCoMKga2J1ZmZlcl9u
ZXh0X2V2ZW50KGtidWYsIE5VTEwpOwo+IAo+IMKgwqDCoMKgwqDCoMKgwqAvKiBOb3cgZGF0YSBo
YXMgdGhlIHJlY29yZCAqLwo+IAo+IMKgwqDCoMKgwqDCoMKgwqByZWNvcmQudHMgPSB0czsKPiDC
oMKgwqDCoMKgwqDCoMKgcmVjb3JkLnNpemUgPSBrYnVmZmVyX2V2ZW50X3NpemUoa2J1Zik7Cj4g
wqDCoMKgwqDCoMKgwqDCoHJlY29yZC5jcHUgPSBjcHU7IC8vIENQVSBvZiB0aGUgdHJhY2VfcGlw
ZV9yYXcgZmlsZQo+IMKgwqDCoMKgwqDCoMKgwqByZWNvcmQuZGF0YSA9IGRhdGE7Cj4gwqDCoMKg
wqDCoMKgwqDCoHJlY29yZC5taXNzZWRfZXZlbnRzID0ga2J1ZmZlcl9taXNzZWRfZXZlbnRzKGti
dWYpOwo+IAoKR290IGl0IG5vdywgSSBzaG91bGQgbWVhc3VyZSBpdHMgQ1BVIHVzYWdlIGFuZCBn
ZXQgYmFjayB0byB5b3UgaGVyZS4KCktpbmQgcmVnYXJkcywKQ2hyaXN0Lgo+ID4gCgo=

