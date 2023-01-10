Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF367C54EBE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Jan 2023 20:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjAJUIT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Jan 2023 15:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjAJUIS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Jan 2023 15:08:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8C965CE;
        Tue, 10 Jan 2023 12:08:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45A12618E5;
        Tue, 10 Jan 2023 20:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77008C433F0;
        Tue, 10 Jan 2023 20:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673381296;
        bh=kU/BAoQAe7Kil4PIZ7I3EL2N+Za0VDdmgJjX1zOmlaY=;
        h=From:To:Cc:Subject:Date:From;
        b=IIueS9EEGQAZ0If5DP++fiejt3dZQc07cOLTalx7EKk3DUfkvBpWREx4lZZAC7Ih5
         9w6V3X6F7tdawD7LxVqvds8FZOr+BvW/t4C3LOAd1KPiDvTaePjDPlxmqIl5GZBMEW
         MEHwH3xnI9KKMZzoB8wK3r2ReYqaSb0DUUc41whxBlaysPFLhAfdqwYH5Ld8Ubn3IC
         WfjDshtiCO9fVSO+dHG45FHAJpBfa/21XmjctEn7I1b/bnqJSEufmeJoCtcZOM2v3x
         FO9SdC0ctnqUGX94EU9CXJVWASbP+8CBNlr1BIg02MeR60gPlP3XilIe1SeKe5tQ+L
         JsATjmHr/OOlA==
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        linux-trace-devel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] rtla: Add hwnoise tool
Date:   Tue, 10 Jan 2023 21:08:01 +0100
Message-Id: <cover.1673380089.git.bristot@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This series present a new tool inside rtla. It is named hwnoise.

hwnoise dispatches the osnoise tracer and displays a summary of the noise.
The difference is that it runs the tracer with the OSNOISE_IRQ_DISABLE
option set, thus only allowing only hardware-related noise, resulting in
a simplified output. hwnoise has the same features of osnoise.

An example of the tool's output:

 # rtla hwnoise -c 1-11 -T 1 -d 10m -q
                                           Hardware-related Noise
 duration:   0 00:10:00 | time is in us
 CPU Period       Runtime        Noise  % CPU Aval   Max Noise   Max Single          HW          NMI
   1 #599       599000000          138    99.99997           3            3           4           74
   2 #599       599000000           85    99.99998           3            3           4           75
   3 #599       599000000           86    99.99998           4            3           6           75
   4 #599       599000000           81    99.99998           4            4           2           75
   5 #599       599000000           85    99.99998           2            2           2           75

Daniel Bristot de Oliveira (6):
  rtla/osnoise: Add helper functions to manipulate osnoise/options
  rtla/osnoise: Add OSNOISE_IRQ_DISABLE option
  rtla/osnoise: Add the mode abstraction
  rtla/osnoise_top: Pass the params to the usage function
  rtla: Add hwnoise tool
  Documentation/rtla: Add hwnoise man page

 Documentation/tools/rtla/rtla-hwnoise.rst | 107 +++++++++++++++++++
 tools/tracing/rtla/Makefile               |   2 +
 tools/tracing/rtla/src/osnoise.c          | 120 ++++++++++++++++++++++
 tools/tracing/rtla/src/osnoise.h          |   7 ++
 tools/tracing/rtla/src/osnoise_top.c      |  84 ++++++++++++---
 tools/tracing/rtla/src/rtla.c             |   4 +
 6 files changed, 308 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/tools/rtla/rtla-hwnoise.rst

-- 
2.38.1

