Return-Path: <SRS0=/PqF=7A=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F569C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 May 2020 02:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E55B9207BB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 May 2020 02:50:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CjNQYzVg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgERCu3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 May 2020 22:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726639AbgERCu3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 May 2020 22:50:29 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA52C061A0C;
        Sun, 17 May 2020 19:50:29 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id a9so6668641lfb.8;
        Sun, 17 May 2020 19:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:references:mime-version:message-id
         :content-transfer-encoding;
        bh=oam3dJJ4/crtTRL/eRuAxPUMONTVhcxSe0tWiKEQVAc=;
        b=CjNQYzVgJb9GMSe0J72qapHzAuYsUoEeOr8gOvtTdA9ElJR3QwTCl0uj7sUIHgIy+t
         l5X7v+4G2lDI8GNAaZqDQQrthE2XdBGbCIP7hXtXUF7eQnJbkGfYM6JeIqhqOOkQhreo
         1oAV/uQHSXPWY0HOXVfQJPEM1huTKek2nzDE2YpYjZOe4/FoM82h+wQYOTbGhasjUmsZ
         v9LmPuUkBq2Vh3r8AvjpbRB5GrMklqVlg+EYgfxbKSQhZpATzvDFoe1dp2TlF5/T6XgD
         jLqFgi9kTUHXzLf9DXIwZrPKxVFcs4RQdZAwcPEnlfMJPHr0d1GC2sBFSXlmRffiSAH1
         q9LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:references:mime-version
         :message-id:content-transfer-encoding;
        bh=oam3dJJ4/crtTRL/eRuAxPUMONTVhcxSe0tWiKEQVAc=;
        b=VPACUeztPiNS3/A1sx4rF5Orb1ibfBw1vgb6mMf7Z82p9MZLGgIBFhArPyFmsAMmFz
         I7vTIzlgMHwtlcOijeZtGhGsAVWn1WotsHwDyR3tlqdNwjOmdnQsdibjbsV6s7Gda/sa
         S2iJylyNFfUq2Y1VrbnzyKeGT+a6AhJ/wPbgilVwV6cBuMcSJ9l5mOXrWzYBAeIB15la
         j8qH+DRxXyWv5ukL0VqcJAGER6NhyhMn0+5tsbsLvOJBsM4/jOXwCqRoxhqM85I1vyq9
         2ElzV5V+XE2WSb9ObFnqzdI8ZNZBOaS0m9SWNIE0pfarPoqvax/d3lk6J1vq/qEUoxCx
         5q9A==
X-Gm-Message-State: AOAM5321aiJ5hKM27W5fXsicBdhhAZaojGRXlwOHIUx4yzLCe45Wl31D
        OdcgXI2lXbfg7A4Pa/0ZIeh+5nW4
X-Google-Smtp-Source: ABdhPJxZNXhf/a/Su+ZtOR0O3Lg9Rt+Ua+DT0J3VJgTo9/b1WBLj8vU2zzf7mjRqGAf/d1T/SoLc5A==
X-Received: by 2002:a19:c50c:: with SMTP id w12mr10042124lfe.23.1589770227415;
        Sun, 17 May 2020 19:50:27 -0700 (PDT)
Received: from N-20L6PF1KTYA2 ([131.228.2.21])
        by smtp.gmail.com with ESMTPSA id d28sm5962870lfe.76.2020.05.17.19.50.25
        (version=TLS1_2 cipher=AES128-GCM-SHA256 bits=128/128);
        Sun, 17 May 2020 19:50:26 -0700 (PDT)
Date:   Mon, 18 May 2020 10:50:25 +0800
From:   "Li Xinhai" <lixinhai.lxh@gmail.com>
To:     "Tom Zanussi" <zanussi@kernel.org>
Cc:     linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: Documentation/trace/events.rst: wrong numbering of sections
References: <2020051515434115672512@gmail.com>, 
        <20200515091126.75db6ec9@gandalf.local.home>, 
        <2449de9a39bd09510f75bd2358cc7ddfd397e93f.camel@kernel.org>
X-Priority: 3
X-GUID: 8C7C185D-E40D-40F5-9BAC-2528207C0581
X-Has-Attach: no
X-Mailer: Foxmail 7.2.13.365[cn]
Mime-Version: 1.0
Message-ID: <2020051810502421237517@gmail.com>
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: base64
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

PkhpLAo+Cj5PbiBGcmksIDIwMjAtMDUtMTUgYXQgMDk6MTEgLTA0MDAsIFN0ZXZlbiBSb3N0ZWR0
IHdyb3RlOgo+PiBJdCdzIGJlc3QgdG8gQ2MgdGhlIG1haW50YWluZXJzIG9mIHRoZSBmaWxlLiBO
b2JvZHkgcmVhZHMgbGludXgtCj4+IGtlcm5lbCAoaXQKPj4gcHJvZHVjZXMgODAwIGVtYWlscyBh
IGRheSEpLiBMdWNraWx5LCBJIGhhcHBlbiB0byBtb25pdG9yIHRoZQo+PiBsaW51eC10cmFjZS1k
ZXZlbCBsaXN0ICh3aGljaCBpcyBtb3N0bHkgZm9yIHVzZXJsYW5kIHRvb2xzKSwKPj4gb3RoZXJ3
aXNlIHRoaXMKPj4gZW1haWwgd291bGQgaGF2ZSBiZWVuIGxvc3QgdG8gdGhlIExLTUwgYWJ5c3Mu
Cj4+Cj4+IE9uIEZyaSwgMTUgTWF5IDIwMjAgMTU6NDM6NDMgKzA4MDAKPj4gIkxpIFhpbmhhaSIg
PGxpeGluaGFpLmx4aEBnbWFpbC5jb20+IHdyb3RlOgo+Pgo+PiA+IFRoaXMgZG9jdW1lbnQgaGFz
IGJlbG93IG51bWJlcmluZyBvZiBpdHMgc2VjdGlvbnM6Cj4+ID4KPj4gPiAxLiBJbnRyb2R1Y3Rp
b24KPj4gPiAyLiBVc2luZyBFdmVudCBUcmFjaW5nCj4+ID4gMi4xIFZpYSB0aGUgJ3NldF9ldmVu
dCcgaW50ZXJmYWNlCj4+ID4gMi4yIFZpYSB0aGUgJ2VuYWJsZScgdG9nZ2xlCj4+ID4gMi4zIEJv
b3Qgb3B0aW9uCj4+ID4gMy4gRGVmaW5pbmcgYW4gZXZlbnQtZW5hYmxlZCB0cmFjZXBvaW50Cj4+
ID4gNC4gRXZlbnQgZm9ybWF0cwo+PiA+IDUuIEV2ZW50IGZpbHRlcmluZwo+PiA+IDUuMSBFeHBy
ZXNzaW9uIHN5bnRheAo+PiA+IDUuMiBTZXR0aW5nIGZpbHRlcnMKPj4gPiA1LjMgQ2xlYXJpbmcg
ZmlsdGVycwo+PiA+IDUuMyBTdWJzeXN0ZW0gZmlsdGVycwo+PiA+IDUuNCBQSUQgZmlsdGVyaW5n
Cj4+ID4gNi4gRXZlbnQgdHJpZ2dlcnMKPj4gPiA2LjEgRXhwcmVzc2lvbiBzeW50YXgKPj4gPiA2
LjIgU3VwcG9ydGVkIHRyaWdnZXIgY29tbWFuZHMKPj4gPiA2LjMgSW4ta2VybmVsIHRyYWNlIGV2
ZW50IEFQSQo+PiA+IDYuMy4xIER5YW1pY2FsbHkgY3JlYXRpbmcgc3ludGhldGljIGV2ZW50IGRl
ZmluaXRpb25zCj4+ID4gNi4zLjMgVHJhY2luZyBzeW50aGV0aWMgZXZlbnRzIGZyb20gaW4ta2Vy
bmVsIGNvZGUKPj4gPiA2LjMuMy4xIFRyYWNpbmcgYSBzeW50aGV0aWMgZXZlbnQgYWxsIGF0IG9u
Y2UKPj4gPiA2LjMuMy4xIFRyYWNpbmcgYSBzeW50aGV0aWMgZXZlbnQgcGllY2V3aXNlCj4+ID4g
Ni4zLjQgRHlhbWljYWxseSBjcmVhdGluZyBrcHJvYmUgYW5kIGtyZXRwcm9iZSBldmVudCBkZWZp
bml0aW9ucwo+PiA+IDYuMy40IFRoZSAiZHluZXZlbnRfY21kIiBsb3ctbGV2ZWwgQVBJCj4+ID4K
Pj4gPiBJdCBzZWVtcyB3cm9uZyBudW1iZXJpbmcgd2l0aGluIDYuMyBzZWN0aW9uLgo+PiA+IG9y
LCB3b3VsZCBpdCBiZSBiZXR0ZXIgdG8gaGF2ZSBzZXBhcmF0ZWQgY2hhcHRlciAjNywgZm9yICdJ
bi1rZXJuZWwKPj4gPiB0cmFjZQo+PiA+IGV2ZW50IEFQSSc/IGl0IHNlZW1zIG5vdCBiZWxvbmcg
dG8gJ0V2ZW50IHRyaWdnZXJzJy4KPj4KPj4gWWVhaCwgNi4zLjQgKGJvdGggb2YgdGhlbSkgcHJv
YmFibHkgc2hvdWxkIGhhdmUgYmVlbiB1bmRlciBhIG5ldyB0b3AKPj4gbGV2ZWwKPj4gc2VjdGlv
bi4gKCM3KS4KPj4KPgo+WWVhaCwgYXNpZGUgZnJvbSBkdXBsaWNhdGUgbnVtYmVyaW5nIGluIGEg
Y291cGxlIG9mIHBsYWNlcywgaXQgd291bGQKPm1ha2UgbW9yZSBzZW5zZSBmb3IgZXZlcnl0aGlu
ZyBzdGFydGluZyBmcm9tICc2LjMgSW4ta2VybmVsIHRyYWNlIGV2ZW50Cj5BUEknIHRvIGJlIGlu
IGEgc2VjdGlvbiA3Lgo+Cj5Xb3VsZCB5b3UgbGlrZSB0byBzdWJtaXQgYSBwYXRjaCBmb3IgdGhh
dCwgTGksIG9yIHNob3VsZCBJPwo+IApJIGFtIG5vdCBzdXJlIHRoZSBjb3JyZWN0IG9yZ2FuaXph
dGlvbiBvZiB0aGVzZSBwYXJ0LCB5b3UgbWF5YmUgYmV0dGVyIHRvIGZpeCBpdCwgdGhhbmtzLgoK
PlRoYW5rcywKPgo+VG9tCj4KPj4gLS0gU3RldmUKPg==

