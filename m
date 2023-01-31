Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57322C636CC
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 Jan 2023 16:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbjAaQbD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 31 Jan 2023 11:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjAaQan (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Jan 2023 11:30:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAAD58673;
        Tue, 31 Jan 2023 08:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 206ABB81D12;
        Tue, 31 Jan 2023 16:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83BFC433D2;
        Tue, 31 Jan 2023 16:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675182613;
        bh=ThZBrAUV3an4YVAjVpxztvzY3NwtSkoPSNZhD30MYDA=;
        h=From:To:Cc:Subject:Date:From;
        b=gTwSpmdRsEkx7sMRMhAfoepkIlnVbxHABQGOp7X548IUkXlJOQvu5Y/CYjSbtj5Sj
         e8uulV3TlZkGbJKRGdZPCWLS9+TRpKB1Hnx8zjsgBQCcXHunp9N0N6Zv/kWok9GJoZ
         CuHRzRVmVIawB5RIYz8EKzZEq+PZ0kg5GybxgT6eXiOgAhh3ewO+fuBqlLfhrxBh8B
         t4yTPIW/ih7OY1g/73yLKKAX+6Jngv/v7IVSyyELTxYlEfzzTco0k//+NNGRMzGjPF
         Pd8CMqDAusK24fft3yTxn6KM+lP4hxno/qH1xwWNhxBs+AsRio0DRAmqHwbzP5yYzE
         duEUsxUB+FZNg==
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-trace-devel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/6] rtla: Add hwnoise tool
Date:   Tue, 31 Jan 2023 17:30:01 +0100
Message-Id: <cover.1675181734.git.bristot@kernel.org>
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

 # rtla hwnoise -c 1-5 -T 1 -d 10m -q
                                           Hardware-related Noise
 duration:   0 00:10:00 | time is in us
 CPU Period       Runtime        Noise  % CPU Aval   Max Noise   Max Single          HW          NMI
   1 #599       599000000          138    99.99997           3            3           4           74
   2 #599       599000000           85    99.99998           3            3           4           75
   3 #599       599000000           86    99.99998           4            3           6           75
   4 #599       599000000           81    99.99998           4            4           2           75
   5 #599       599000000           85    99.99998           2            2           2           75

Changes from v1:
  Add rtla-hwnoise to the rtla documentation index
	(kernel test robot/Bagas Sanjaya)

Daniel Bristot de Oliveira (6):
  rtla/osnoise: Add helper functions to manipulate osnoise/options
  rtla/osnoise: Add OSNOISE_IRQ_DISABLE option
  rtla/osnoise: Add the mode abstraction
  rtla/osnoise_top: Pass the params to the usage function
  rtla: Add hwnoise tool
  Documentation/rtla: Add hwnoise man page

 Documentation/tools/rtla/index.rst        |   1 +
 Documentation/tools/rtla/rtla-hwnoise.rst | 107 +++++++++++++++++++
 tools/tracing/rtla/Makefile               |   2 +
 tools/tracing/rtla/src/osnoise.c          | 120 ++++++++++++++++++++++
 tools/tracing/rtla/src/osnoise.h          |   7 ++
 tools/tracing/rtla/src/osnoise_top.c      |  84 ++++++++++++---
 tools/tracing/rtla/src/rtla.c             |   4 +
 7 files changed, 309 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/tools/rtla/rtla-hwnoise.rst

-- 
2.38.1

