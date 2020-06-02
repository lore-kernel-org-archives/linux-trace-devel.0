Return-Path: <SRS0=8+AL=7P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7C5C433DF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Jun 2020 14:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DDEE206E2
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Jun 2020 14:09:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iQqR+8zm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgFBOJS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Jun 2020 10:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgFBOJS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Jun 2020 10:09:18 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18A8C08C5C0
        for <linux-trace-devel@vger.kernel.org>; Tue,  2 Jun 2020 07:09:16 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id r9so3074420wmh.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Jun 2020 07:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K3EQ0aH/zoN+K+/0qfMC+9AMF++VOyAiB+5WgCkeFLc=;
        b=iQqR+8zmaXcGjAVokAMCuWFd38P2dkFD1QWvyhodUJGWSW+RlRYppvvbnbGptop9ac
         WtKdvwanyatMXcYop0fDtqHe3o64ERDuCMh4vyCZ3DQ/ylYhzYS1jXqgc01NmW0sNFmh
         Vc80TBFU9BQHEaikb2ikK8vYQ0rLZj0LR7VTTLEGODPMdl63ChE/o+OB1aCU0hEDui6E
         tOHR7G7RCo6TDvvEFHU97WzZqD6TGVDqwmUFVyNMOK7tIuG8MY4Gnvg1xUpqKD5sRhJb
         Hyav6V13iS1dcV8gSQ9ZVmKMKYHkdvIhSo3MGGVJ6uU0d7H7Nb+atXSFoF4atnoXMh1m
         aaYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K3EQ0aH/zoN+K+/0qfMC+9AMF++VOyAiB+5WgCkeFLc=;
        b=B3OWV0lNbHFul91zCswePRyx18C4FPBd+eaKX6fSeGKupBC8r+3MRTJquUA7YcG02h
         fXOog4q4D3geKd0NKrmveQewZu5oP4DF28GtmpiJ37Qjp4eYYVVbDtMqkmXgDL/8Qhpo
         eCUb8s3Fe6x4pmH7ISUrBP/z2+1aundCOW3GP9+hsJorh3mZUWanqXBePpf+3065cPiP
         9TEFFPjPlvQbpyqxK2SfROuacfWnHO1njg63jitY2kf/ci1/xTab2ngopM5SzrfCh+ho
         CARco1Pl3zwTvi+6OxNRuJvrB9G9eoTsA+8mExE6vgHFCdZY9Wvl1jqFK+KMKtnsou3c
         zBDw==
X-Gm-Message-State: AOAM5331ErrwWCrKX/7qLMFDR8ngQXa1nCi6wWq2L8BxAyTS8iCPS28p
        G4GG7ZxHWtVUyH/suBGzi2JMF9b4wTs=
X-Google-Smtp-Source: ABdhPJwev3CgO21GmnvnOQERg1SzHDpaL/dC4lTev/9T/771A7LpNdsnbcg7byasRtBzbsE5A/PaUQ==
X-Received: by 2002:a7b:c0cc:: with SMTP id s12mr4444195wmh.111.1591106955428;
        Tue, 02 Jun 2020 07:09:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w3sm3849551wmg.44.2020.06.02.07.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 07:09:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/3] New trace-cmd "set" command and changes in "start"
Date:   Tue,  2 Jun 2020 17:09:09 +0300
Message-Id: <20200602140912.78031-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

"trace-cmd start": Enable to run and filter a command.
"trace-cmd set": Introduce a new sub command. It works the same way as
"start", except it does not clear the ftrace state.

Tzvetomir Stoyanov (VMware) (3):
  trace-cmd: Enable "trace-cmd start" to run a command
  trace-cmd: Add new subcommand "set"
  trace-cmd: Man page for "set" subcommand

 Documentation/trace-cmd-set.1.txt   | 254 ++++++++++++++++++++++++++++
 Documentation/trace-cmd-start.1.txt |   2 +-
 tracecmd/include/trace-local.h      |   2 +
 tracecmd/trace-cmd.c                |   1 +
 tracecmd/trace-record.c             |  79 +++++++--
 tracecmd/trace-usage.c              |  37 +++-
 6 files changed, 360 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/trace-cmd-set.1.txt

-- 
2.26.2

