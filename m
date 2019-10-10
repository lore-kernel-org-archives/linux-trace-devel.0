Return-Path: <SRS0=o8EP=YD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 280B3C10F14
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 16:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B23C21835
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 16:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfJJQnv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 12:43:51 -0400
Received: from mail-io1-f48.google.com ([209.85.166.48]:35263 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfJJQnv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 12:43:51 -0400
Received: by mail-io1-f48.google.com with SMTP id q10so15293094iop.2;
        Thu, 10 Oct 2019 09:43:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=eDC918nTSS5JgSXrNuvSCpxX8XwXIrnEoxRVv+U2dNY=;
        b=fqSAJHmR9ew1yHUUgQv+2cSbec+E5B42FPT0SnDU/x7fKw1K90uNJEaRYUFUM5kosC
         Hll8SxUh6ify4Zs+R0X/1fjgtK69H0IW07+JVEV4DiJWlOhrdUq+8uYkTgoidWxU3+PH
         n8ybUUQG4GCauzXxyHw/hsPq7YYpmkYet8/kiQlYLN/2obu58w7cuiERsXx5zyh5U8jQ
         OSnxNv/lKmMSR6u7cxGohWs+IyHycGABInLgldpd8yEMUOMHF2PQsffMn2edVbF8RGdu
         edeYQvFP7Yjjxl0lSlakaAZen9r6XSJ5EaDtga9dhomsff6k3NOKYRpNyLpNiMH19lyA
         Y97Q==
X-Gm-Message-State: APjAAAU/AXIKo1zFOe5PAQP3A2aV3wioPUMZ2hurwRnUctDC1MZLj+ig
        B3fn7ZX+xFXz1eHRqIRbuBgUHmGrSm6pXaTenRTmnFRPJ9c=
X-Google-Smtp-Source: APXvYqzrmSb8jVzNyzNTs+R1/p2ZJER6ZZKPujuTjonUbw5qHPwg2O6Sbebgwnh9QJlEVUrbR1dd+PPVlErlKuM3njI=
X-Received: by 2002:a02:19c1:: with SMTP id b184mr5415455jab.54.1570725830340;
 Thu, 10 Oct 2019 09:43:50 -0700 (PDT)
MIME-Version: 1.0
From:   Francis Deslauriers <francis.deslauriers@efficios.com>
Date:   Thu, 10 Oct 2019 12:43:39 -0400
Message-ID: <CADcCL0iE+VS9O6dYNDHogjs-QYOYpDUbX5D5-iwsdhkk1zPxQg@mail.gmail.com>
Subject: Tracing Summit 2019 - Videos
To:     linux-trace-devel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc:     info@tracingsummit.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi all,
The videos of the Tracing Summit 2019 talks are now available on Youtube [1].

[1]: https://www.youtube.com/playlist?list=PLuo4E47p5_7ZeRpUZEUyF2kWyA6KzTTkI.

See you all next year!

-- 
Francis Deslauriers
Computer Engineer
EfficiOS inc.
