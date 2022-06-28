Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71526C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jun 2022 12:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345379AbiF1MQ1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 08:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345193AbiF1MQ1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 08:16:27 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A9125C7A
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Jun 2022 05:16:25 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id cw10so25390283ejb.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Jun 2022 05:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6negqGRrk5q/ycDPp/gKB5kwdB1/26rxTmlQvHZ1kkM=;
        b=b561UTVZFBxiOXNGd9SZJkUto3oW5u7oDbxAWiIFOf9GsHFyIkx3+5gv1QrX5ZvTFv
         UPzQzy3JCprL80fFAGEJQ32NOrfBYosJbLDDgg0YRdpkETLOW8edxPiSZSkKtTuocPTl
         /RFVx7rzo9i3fyTo2pbezNPusv7sXmauezymosR3kB1Q6aqZjK/+ORFF4pals7MQdBYY
         C/13/Gd7yeobeQy8ushYAXaKFhcB9rAhp4n9deG0gXmOa4x/UH0VLCHlmlXBBw5nZMlV
         aMP8L4PDTkA54ucd7Ff10gAKOfYQY26eEnBIVmUGEiJ068YgQpiJRkEGsHy/+8NNbfIw
         JWdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6negqGRrk5q/ycDPp/gKB5kwdB1/26rxTmlQvHZ1kkM=;
        b=pXvflJGYRoG/LlZDJU2j/OmmkVSY9n4nfUJl5Ftma9qmahlIlDhvel1AZLxyzbft7y
         1IQBSXh5eERAkp0jJjgBOOK2Z0TrUveX2fJWYxqS47A+KHTAXmymUH1FrqwF+0qh83QZ
         tlliLoX3brDocmRQutmrdI8WnOGaZljU+pcN38GbC/vUUwMVZJ2znVdnO5a2WWhUCF3p
         n+UmBHu/T17q+uuuudJHUOY5N7DdjSJODxrp8VEVBRJPiUqLbXgRSwFoHBBIqtkXx2wg
         9f4Yg9nLhr4FBD3es9A1KgL+xt48OOX3STi7Frki9GCU57jcx6zLhVt1VN4t5UNzVXc4
         J5LA==
X-Gm-Message-State: AJIora+cts/MSR/yQmdwbbYhIN01mwLbBGcRjGpGEcgq9fiHY4jWfUzo
        pclyY8903BxcSHwRTBNXK0JOVaJLnEWbDw==
X-Google-Smtp-Source: AGRyM1sXBb93Mr1xSq1kHVIihUVd//nRfJNdKg7PKgNXVi0jGK8tBOXfoC1joLKKJRUF0hHekuqfkA==
X-Received: by 2002:a17:906:38ca:b0:722:e836:1d85 with SMTP id r10-20020a17090638ca00b00722e8361d85mr17492748ejd.194.1656418583726;
        Tue, 28 Jun 2022 05:16:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7c04e000000b00431962fe5d4sm9512780edo.77.2022.06.28.05.16.22
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 05:16:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 0/3] trace-cruncher: ftrace uprobes support
Date:   Tue, 28 Jun 2022 15:16:18 +0300
Message-Id: <20220628121621.572506-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ftrace uprobes can be used to create dynamic events for user functions.
Tracing user function can be very useful functionality for trace-cruncher.

Known issues, that will be addressed with subsequent patch sets, before the
next trace-cruncher release:
 - Improve the logic for ctrl-c handling and interrupting the trace.
 - Improve the logic for monitoring target PIDs - stop the trace when target
   process exits.
 - Implement unit tests.

v4 changes:
 - Removed accepted patches from the patch set.

v3 changes:
 - Implemented logic for finding the full application name in the C code.
 - Renamed a few internal functions and variable with more specific names.
 - Coding style fixes.

v2 changes:
 - Moved the uprobe C code into the ftrace-utils.c file.
 - Reused internal functions from ftrace-util code.
 - Renamed utrace start and stop to enable and disable, to be consistent
   with the other APIs.
 - Do not call utrace disable in the urtace example, as this logic is
   triggered by the destructor.
 - Changed the logic for allocation of internal dynamic array - double the
   array size on each reallocation, instead of increasing the size with
   hard-coded constant.
 - Added support for running a program with arguments for tracing.
 - Do not run the program for tracing in a separate shell.
 - Coding style fixes and optimizations.

Tzvetomir Stoyanov (VMware) (3):
  trace-cruncher: ftrace uprobe raw API
  trace-cruncher: High level wrappers for ftrace uprobes
  trace-cruncher: Example script for uprobes high level API

 examples/user_trace.py |  39 +++
 setup.py               |   4 +-
 src/ftracepy-utils.c   | 746 +++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h   |  21 ++
 src/ftracepy.c         |  45 +++
 5 files changed, 853 insertions(+), 2 deletions(-)
 create mode 100755 examples/user_trace.py

-- 
2.35.3

