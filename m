Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991DDC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 04:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 769376144E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 04:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhD2ECI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 00:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhD2ECI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 00:02:08 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A949C06138B
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 21:01:22 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id n2so97767755ejy.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 21:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xY9TfZo5rTk+8RKe2yCKNh37HoDfqxS5Uo+TAcmcziQ=;
        b=crs4/a+QMnmPoxyRExEWPMDTVmRCte4scMr0IRJPxn2FGfdJsJG1o8Q/8XU2S31nS9
         lrQdS6rGj1bcS1VArpuMdb6sUGPo3ECZrHW2SY1Bd/dIOPKWOXBvFSElbxVgXgw9MWQw
         dNbRXLj/418Gik2iQD8LDY1O4+QWjugNuTo1+Mm36oW53pot1njCWIadsfqTH+sKABo/
         Dy7s2A3QqlFwtT8K6yPrDlzDMKIvONONhXyZZj1xptKKqkhOBi9HP98YYc4yr3khc9fQ
         IqG6FYB9mAa39bUpDqEr3s1Q3nl4+kZ3V4I5c1eSOQ3pYOB9oe2JxX5JvpakjQfzSoCt
         GX8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xY9TfZo5rTk+8RKe2yCKNh37HoDfqxS5Uo+TAcmcziQ=;
        b=D7jRqJhR/3WAsj4M0MjtFk38ueUMitDVaiV4FXtXlYZ3qaNdDZv1B1pbMjwBAu9y5v
         xHjCI3FaFinV5Qxk7NG2JVi7ZnhIC8rU7cHn1D0EdtBN+J3W1JJI7Umdkn+B4R8age2j
         CXDHCzGUmPoL0MiaF79gnqGwaD6wZ05WFGLVNsTMhRmgPNRFsILwSFiRX+aNBnIu0B5S
         kG/OmMEks6khcNE1XNZZoFJ1o0kWCRMS9Uw8CH2H5oWq54UwRfS5CeCHqNS6hq3Vp3tK
         XxLy7LU399PM9H5MiS5TsiVLQVeM9fLofxxqPNNkA5ST/Z1qJqD58IMiDERg1+68Nxmq
         jxaw==
X-Gm-Message-State: AOAM533d4cLM2UXKExe/ty6Vyrjl5u3ePl9v6IJw4IG2+xBWuMoF5uWI
        trxTTi9oE/nFtGeWWUF/4iJdYIzohKXlKA==
X-Google-Smtp-Source: ABdhPJxCk5TY1IA/0Q8FE6JlczCZw1K0+SWVcVuyp/W27qMc9+G4abJNz7ZKY5N5m9c0gkCUtDIyDg==
X-Received: by 2002:a17:907:765b:: with SMTP id kj27mr17132308ejc.537.1619668881152;
        Wed, 28 Apr 2021 21:01:21 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z26sm1040740ejl.38.2021.04.28.21.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 21:01:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/7] Bump trace file version
Date:   Thu, 29 Apr 2021 07:01:12 +0300
Message-Id: <20210429040119.843617-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Changed the trace file version to 7 and added support for choosing 
the desired file version.

v2 changes:
 - Include "Check if file version is supported" patch in the set, as other
   patches depend on it.
 - Reorganized the order of the patches, put the clean up patch "Remove
   unused private APIs for creating trace files" first.

Tzvetomir Stoyanov (VMware) (7):
  trace-cmd library: Remove unused private APIs for creating trace files
  trace-cmd: Check if file version is supported
  trace-cmd library: Bump the trace file version to 7
  trace-cmd library: Add new API to get file version of input handler
  trace-cmd library: Select the file version when writing trace file
  trace-cmd library: Extend the create file APIs to support different
    file version
  trace-cmd record: Add new parameter --file-version

 .../include/private/trace-cmd-private.h       | 29 +++---
 lib/trace-cmd/include/trace-cmd-local.h       |  2 +-
 lib/trace-cmd/trace-input.c                   | 19 ++++
 lib/trace-cmd/trace-output.c                  | 98 ++++++++++---------
 lib/trace-cmd/trace-util.c                    |  7 ++
 tracecmd/trace-dump.c                         |  7 ++
 tracecmd/trace-record.c                       | 25 +++--
 tracecmd/trace-restore.c                      |  4 +-
 tracecmd/trace-usage.c                        |  1 +
 9 files changed, 121 insertions(+), 71 deletions(-)

-- 
2.30.2

