Return-Path: <SRS0=Ttn5=65=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30C5C433DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 May 2020 07:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA4BC20728
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 May 2020 07:43:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sRndifWO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgEOHns (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 May 2020 03:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726646AbgEOHns (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 May 2020 03:43:48 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B869C061A0C;
        Fri, 15 May 2020 00:43:46 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id u6so1170867ljl.6;
        Fri, 15 May 2020 00:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:mime-version:message-id
         :content-transfer-encoding;
        bh=6fcd89wgkSgqVBNdrPfzmqnnEY3Nqs7eMpEhxlqoW28=;
        b=sRndifWOeUllz2bNNyLXMNWvsHJ4ALq6Y4YEs4M0JodNYQmEVzz19fSROv2d4VdgQQ
         apxYkq5M7fvpMwNBblkBomDhRaruDw3mL5X+Ae8RPLw5lUn/9Ih95B9L9XmdQFSuwdWE
         eCfQKt81lAW1Ovb+rpzIQKBvn7xIPzt5Y56i6FWlAIN8vAowThL1CfDjkBVsgMBNaUv9
         YY/PjHwpTczSx06TYf/unI98i8rq8/yM3sW7uFB5RyQt8sM1uG4gYm8pGKkOPQsed+fg
         HrOcEka3S8B4z3Msdtu40ngo4PflowOBAKI/pdK9dBrN85sW6RV3QAuW9rjEvXaO+KDw
         QmaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:mime-version:message-id
         :content-transfer-encoding;
        bh=6fcd89wgkSgqVBNdrPfzmqnnEY3Nqs7eMpEhxlqoW28=;
        b=TF6W75ftXa+1v2opXd7gQPl7Wi33//YrPiQ29maJjHj1xHelraHIswy1TJ8omzU6xn
         IxY883hFGj181Zo7wfd88c1/q/uMHf4KeDVulQVTJ0uYqPY1hIjHjGg9EocgPyB3+fGp
         xWbzDw2oNFIjYawK+lBT8OCPgE0CTPuh+F8XPnWPGCqvu11lNLjqTjEzfRWrO92Pl9RH
         CixknnhvJLFDGbt0d3QvJ6uNJwE34fsmUWy6TXPYJY9zITFor2o6CfZD26/xhthYnRFu
         Hw/n2JMaXohdkZsaGMU3eZyjZszhCzejC7rL5+rLccQY4LM3rxiL61HhfaopKE4a+ORj
         MHmg==
X-Gm-Message-State: AOAM5336KqsYz4yhFd8rvvTjVKkoifi9DoodSOyXdGRm2imXllYqmIR+
        hVXsW8UUdAWu8QV2kS3FV3erk4Ie
X-Google-Smtp-Source: ABdhPJyLZUc9KGbWwsBvqCL5JnbLYec4TU3CNXyAvxJVFJby7fzBJDz5MTImfSLj6OxhTKJ0uBQ/2w==
X-Received: by 2002:a2e:9641:: with SMTP id z1mr1269503ljh.215.1589528624700;
        Fri, 15 May 2020 00:43:44 -0700 (PDT)
Received: from N-20L6PF1KTYA2 ([131.228.2.20])
        by smtp.gmail.com with ESMTPSA id q6sm723028ljg.67.2020.05.15.00.43.43
        (version=TLS1_2 cipher=AES128-GCM-SHA256 bits=128/128);
        Fri, 15 May 2020 00:43:44 -0700 (PDT)
Date:   Fri, 15 May 2020 15:43:43 +0800
From:   "Li Xinhai" <lixinhai.lxh@gmail.com>
To:     linux-trace-devel <linux-trace-devel@vger.kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>
Subject: Documentation/trace/events.rst: wrong numbering of sections
X-Priority: 3
X-GUID: A3EF515F-BBED-4884-B6FD-8058B47A8C19
X-Has-Attach: no
X-Mailer: Foxmail 7.2.13.365[cn]
Mime-Version: 1.0
Message-ID: <2020051515434115672512@gmail.com>
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: base64
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

VGhpcyBkb2N1bWVudCBoYXMgYmVsb3cgbnVtYmVyaW5nIG9mIGl0cyBzZWN0aW9uczoKCjEuIElu
dHJvZHVjdGlvbgoyLiBVc2luZyBFdmVudCBUcmFjaW5nCjIuMSBWaWEgdGhlICdzZXRfZXZlbnQn
IGludGVyZmFjZQoyLjIgVmlhIHRoZSAnZW5hYmxlJyB0b2dnbGUKMi4zIEJvb3Qgb3B0aW9uCjMu
IERlZmluaW5nIGFuIGV2ZW50LWVuYWJsZWQgdHJhY2Vwb2ludAo0LiBFdmVudCBmb3JtYXRzCjUu
IEV2ZW50IGZpbHRlcmluZwo1LjEgRXhwcmVzc2lvbiBzeW50YXgKNS4yIFNldHRpbmcgZmlsdGVy
cwo1LjMgQ2xlYXJpbmcgZmlsdGVycwo1LjMgU3Vic3lzdGVtIGZpbHRlcnMKNS40IFBJRCBmaWx0
ZXJpbmcKNi4gRXZlbnQgdHJpZ2dlcnMKNi4xIEV4cHJlc3Npb24gc3ludGF4CjYuMiBTdXBwb3J0
ZWQgdHJpZ2dlciBjb21tYW5kcwo2LjMgSW4ta2VybmVsIHRyYWNlIGV2ZW50IEFQSQo2LjMuMSBE
eWFtaWNhbGx5IGNyZWF0aW5nIHN5bnRoZXRpYyBldmVudCBkZWZpbml0aW9ucwo2LjMuMyBUcmFj
aW5nIHN5bnRoZXRpYyBldmVudHMgZnJvbSBpbi1rZXJuZWwgY29kZQo2LjMuMy4xIFRyYWNpbmcg
YSBzeW50aGV0aWMgZXZlbnQgYWxsIGF0IG9uY2UKNi4zLjMuMSBUcmFjaW5nIGEgc3ludGhldGlj
IGV2ZW50IHBpZWNld2lzZQo2LjMuNCBEeWFtaWNhbGx5IGNyZWF0aW5nIGtwcm9iZSBhbmQga3Jl
dHByb2JlIGV2ZW50IGRlZmluaXRpb25zCjYuMy40IFRoZSAiZHluZXZlbnRfY21kIiBsb3ctbGV2
ZWwgQVBJCgpJdCBzZWVtcyB3cm9uZyBudW1iZXJpbmcgd2l0aGluIDYuMyBzZWN0aW9uLsKgCm9y
LCB3b3VsZCBpdCBiZSBiZXR0ZXIgdG8gaGF2ZSBzZXBhcmF0ZWQgY2hhcHRlciAjNywgZm9yICdJ
bi1rZXJuZWwgdHJhY2UKZXZlbnQgQVBJJz8gaXQgc2VlbXMgbm90IGJlbG9uZyB0byAnRXZlbnQg
dHJpZ2dlcnMnLgoKCgo=

