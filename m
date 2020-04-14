Return-Path: <SRS0=o21U=56=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E52C2BA19
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 11:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A05CE20768
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 11:41:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iaoXYOlI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439453AbgDNLlR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Apr 2020 07:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729851AbgDNLlP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Apr 2020 07:41:15 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56636C061A0C
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 04:41:14 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ng8so5156379pjb.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 04:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=OQiWdkZjmhhiyVKGjjJY+VfFaLEFcNB6GE0Vij3fpcE=;
        b=iaoXYOlIL8OI70kjnZx6QY3GwVn0W9vN8ejoQU4z9eLyUkBVs6Dj0ltfLHOQoPTkdJ
         acRbDjMJgEzMR8WG9vqoGxWXG7EQ8NZ2iSUmTFKz17IjWZkNlPNt0+2Wnn9D2nXH5X/4
         KkVRLPcB49+Gl1lY0JkMbyIR7bCRLwHGujCqhN1TZwZM6Vz9s7a37plYHXe9qHeuiuB5
         OzKjoDQVSS6XyIMjKS6Io+g890WGXWuFSYpNdWwOhn78dmq1gQSp3kNK/P+AiXt2ZQYr
         py+c4C0m5md4SBQOtGHMBvJsmetUMlWbAB7q0oOeHMKXRuZJ8IpTE2Rqq2UYIzC6uSfe
         OgqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=OQiWdkZjmhhiyVKGjjJY+VfFaLEFcNB6GE0Vij3fpcE=;
        b=bAxMFe0M6lFjNr8QLtPJA4+3AP1It55fgB9VZL8NLe2I83QvKBDRzsWN1GGGuvWprM
         hoC2Yj7NJLMcj9+Jxa7Dl0bgfrWtKw+BmuTHc+y9uj1+qtKVaXl4SyFfGur101UDtdNm
         q461XP7+nMMKMpPkM9yujRFHkEJTXBRaacZQT5sAcVC3PwUjgvft0UTAlzr9P/1V1Jjy
         XRCsWA57Rzo3qieyBo6Qf0QGYrQeNSOULnEL+zPzFvC2r7YBpHhGx00vInrih7xXBlR6
         GnGJzN2mqgyXQDI3bOMkCL9XT6Fq9qRQ7C2o3sOSTAjJZeTfw568hX7DQiT2jVCtamVw
         bkUA==
X-Gm-Message-State: AGi0Puas+QVPh5eZCq/++3ehWtl7vXFrzvYzZ91ZRMh8Id2dhgH3wu8h
        Zx1PReQUV0aqTCEGjy4549U1J48q7YbEFJsbq+WDMDyGoBc=
X-Google-Smtp-Source: APiQypJ9burOTdRowHz20XuhcFTVbXecLjdCfhx2iBj/zMxtNgMeoaWY7WNMWr9mDBd3dSSQSUpW7H4UaOqw+pibZgc=
X-Received: by 2002:a17:902:a515:: with SMTP id s21mr2357329plq.41.1586864473821;
 Tue, 14 Apr 2020 04:41:13 -0700 (PDT)
MIME-Version: 1.0
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 14 Apr 2020 14:41:02 +0300
Message-ID: <CAPpZLN6WJLZ=RYxLvFwe2ks2h1Mk+ENi7NBokL0WtK24RbmtFg@mail.gmail.com>
Subject: Repo with all POC time sync patches
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

Here you can find a repo with all POC time sync patches applied. All
of them are available also in patchwork.
I wrote a short description in the README, how the logic can be tuned
to test different flows.

https://github.com/tzstoyanov/trace-tsync



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
