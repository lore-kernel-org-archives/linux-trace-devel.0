Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AB0C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EDF720811
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfCNPKb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:10:31 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38801 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfCNPKb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 11:10:31 -0400
Received: by mail-pf1-f194.google.com with SMTP id n125so4034684pfn.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2019 08:10:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1fdtYbX+zU9ph49sjZk+m7gHl51FcemgMN/l01TkGg8=;
        b=nMaZ3NgTlqZc6BWx4dBeMJrVJN3PGxBIVW9AZ06BONPQfbK0RLJk35HgX842MRLwSc
         N1xOuztFhe21ReIWtYmmBVy7NMCwphS7WndydIERfyG0l/ztIIxYc9L1d5UUJ/9XZkQD
         haDfuNaSTDKyBYAUDmkq5tjNKCsL3A9hyPeuq7gO6reMJF0Kemg9xfpkEumdkhFPr5Mr
         L4RJpN/NTekDCd7nqwsQcG3IKMj11gak5JAjr/SjxyxpoMo0hmydthvGMQpWqjv8DuAa
         0n6RSFAga7C8C/3RZ7H0crgjgPoC6EQr8hwFK7XwCYnA67gY7FU/sjxUvsUhrlGsH5wH
         nJgw==
X-Gm-Message-State: APjAAAUh6X2GgwKk5FbdXrJlbi9G+DXWh5gq7m5sL0qswZq7KfOeN05m
        GCQMHnMfZL+ycTb7FkuMPcg=
X-Google-Smtp-Source: APXvYqwvfrcz8Mne0Ldz42T0+uAUHTsPoebIBCcjzs0g13erqb6YPatpLxR7kdPeG4T+dv5uDY3MUQ==
X-Received: by 2002:aa7:90c7:: with SMTP id k7mr49249717pfk.186.1552576229875;
        Thu, 14 Mar 2019 08:10:29 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f65sm8165585pfg.98.2019.03.14.08.10.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 08:10:29 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/12] Various modifications and fixes toward KS 1.0
Date:   Thu, 14 Mar 2019 17:10:00 +0200
Message-Id: <20190314151012.905-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Most of the modifications are minor except patch [PATCH 08/12] which
fixes a major memory leak.

Yordan Karadzhov (12):
  kernel-shark: Fix a spelling typo in KsMainWindow class
  kernel-shark: Fix a typo in an error message from libkshark-configio
  kernel-shark: Make KsSession::importFromFile return status flag
  kernel-shark: Error message if the opening of the session file fails
  kernel-shark: Disables automatic quotation for errors in KsMainWindow
  kernel-shark: Load Last Session from command line
  kernel-shark: Add destructor for KsGLWidget
  kernel-shark: Fix memory leak in KsPlotget::getTaskColorTable()
  kernel-shark: Avoid the unnecessary calls of KsGLWidget::loadColors()
  kernel-shark: Avoid 0/0 spliter ratio in KsSession
  kernel-shark: In model, handle the case when all bins are empty
  kernel-shark: In collections, handle the case when the data is small

 kernel-shark/src/KsGLWidget.cpp         |  8 ++++++--
 kernel-shark/src/KsGLWidget.hpp         |  2 ++
 kernel-shark/src/KsMainWindow.cpp       | 25 +++++++++++++++++--------
 kernel-shark/src/KsMainWindow.hpp       |  4 ++--
 kernel-shark/src/KsPlotTools.cpp        |  2 ++
 kernel-shark/src/KsSession.cpp          | 20 +++++++++++++++-----
 kernel-shark/src/KsSession.hpp          |  2 +-
 kernel-shark/src/kernelshark.cpp        |  9 ++++++++-
 kernel-shark/src/libkshark-collection.c | 20 ++++++++++++--------
 kernel-shark/src/libkshark-configio.c   |  2 +-
 kernel-shark/src/libkshark-model.c      |  9 +++++----
 11 files changed, 71 insertions(+), 32 deletions(-)

-- 
2.19.1

