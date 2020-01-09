Return-Path: <SRS0=s3Jp=26=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A5CC32771
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 12:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E02CC2077B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 12:21:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aeRRm5rL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgAIMVA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 07:21:00 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46818 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730882AbgAIMVA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 07:21:00 -0500
Received: by mail-lj1-f193.google.com with SMTP id m26so6949130ljc.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Jan 2020 04:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=85CJY08yJ5/hcBxDlno0dNduNx/52fzqmJUQj6xva+A=;
        b=aeRRm5rL8uaO3+Y/VgrSxCKu31mBMMRcTmGY6M2fIGTVqW78r5USuDHYUf/r0mRobg
         lUh/dnQXXD4p+J8eTlG7PmXhKH+rzrvPh1DlV9l4MwklaGTdhsn5byyzVpgqHOHxsId8
         lStzLPNvpPJqbQEHgOpnWc5RtZ60j9yzJIJ9SX+Ii5avGL/e4bXcxBM9m24UnoiNLaEc
         /YJBU59u51vSGOHSZj7csLszzcZ3wA673Gg4ENrGQ/xPmuG3rZz5CboDygqU6Kc9p/H/
         LyLGLTsipZoJ5zp7fthHBs7YUhOOQR92WycnxcOHl961Aha0ruHL4k06WO+MVvZ+WUyq
         kfgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=85CJY08yJ5/hcBxDlno0dNduNx/52fzqmJUQj6xva+A=;
        b=Rlob1Kb7snFpmHXA8DPM95Hna9Se5xRKuruOkWJUFJJzloXsEad9CHoxH1sj6N4INz
         CxCvYBmVMuLi85qDbkL077bbdCdawPzMAHsg0c+01u6JVM1EN2i14uOcryO9CIH6L35c
         FVSavZQMsztMtjTeA92arvgUkp6u+XAg2VhT6Lsv3eYHieLNDiSiy2uSxx2A9VYwsboU
         HLp3lo+Ub562dVsq6mBM8tx8D97qLsDRxzi8rWy55aFL0Esk/1h7NMIKIwdAhSDEdSfr
         ttRBv7s4f74YQWjZJvLhuvRqFzttGPAMdBDTWYsUFIXZTKCfWANDqo6rGQ1ZfesjnKuS
         UMSA==
X-Gm-Message-State: APjAAAVGKI6YPM0ddXpEuk+o5E68fOdAampDlfaJEIKbfkQi/CUkvszv
        aiOfj2cAYV7/l6KtTAOxrtVs9NT77gg=
X-Google-Smtp-Source: APXvYqzX/2kR8TpKIIPbTBOx5TP5hW/67Qk5oyI6F0P9anmTFSwVuYrI/fMqEY7BT2BkaarSN110hA==
X-Received: by 2002:a2e:a37c:: with SMTP id i28mr6497010ljn.118.1578572458599;
        Thu, 09 Jan 2020 04:20:58 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f16sm2877251ljn.17.2020.01.09.04.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 04:20:57 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3]  Add new trace-cmd sub-command "dump"
Date:   Thu,  9 Jan 2020 14:20:52 +0200
Message-Id: <20200109122055.286290-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new trace-cmd sub-command "dump" prints all meta data
information, stored in a trace file. It also can be used
to check if a file is a valid trace file, created by trace-cmd.

Tzvetomir Stoyanov (VMware) (3):
  trace-cmd: Implement new sub-command "dump"
  trace-cmd: Man page of "trace-cmd dump" sub-command
  trace-cmd: bash completion of "trace-cmd dump" sub-command

 Documentation/trace-cmd-dump.1.txt | 132 +++++++
 tracecmd/Makefile                  |   1 +
 tracecmd/include/trace-local.h     |   2 +
 tracecmd/trace-cmd.bash            |  21 +
 tracecmd/trace-cmd.c               |   2 +
 tracecmd/trace-dump.c              | 615 +++++++++++++++++++++++++++++
 tracecmd/trace-usage.c             |  20 +
 7 files changed, 793 insertions(+)
 create mode 100644 Documentation/trace-cmd-dump.1.txt
 create mode 100644 tracecmd/trace-dump.c

-- 
2.24.1

