Return-Path: <SRS0=Uv3S=T6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29FC5C28CC0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 May 2019 13:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F14982596C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 May 2019 13:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfE3NQW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 May 2019 09:16:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50363 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfE3NQW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 May 2019 09:16:22 -0400
Received: by mail-wm1-f68.google.com with SMTP id f204so3973947wme.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 May 2019 06:16:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D1sa3/F9PgJHm4reFPEIHcYQ1PQOLyug1RUAPXfV2qk=;
        b=Pn5ib8gr+yEMLrVrg4CVaiQ4P8PYXx9PVzz7MCi2U6mOM3b9hzdZxrmhBIcycTOrPY
         fujoIL2x/P18T4SZs8ntuPhCfDDfTKNJJgPY4QIQ/AUEpVqw8GYngMO89ZqBitrPMisi
         ML162Uzx8vZyDCP1jX3PdffgAPVdNa3cX236qPPiZKAdLEdJm4gIWueIN0Gb3nRAdrOP
         LHMTE9+Gm0ib7UCAEKm3JQ0EdRNmzLa/azue9hDAAtSh9skJ/uRCAR+u5mmrgnQ/DYYC
         /ombfgWMXxNOmmB3ogYPG3o6LET2+fGa6aIO0vMttsL1LmBj7TAUpkDSXMVLpW2U3O6R
         7/dg==
X-Gm-Message-State: APjAAAVhkoAn1Jfn5H0Usku2A417rFJMIQroqMuCR65u0aL8MoxiNrkX
        DE9XjLLkxiNLw7ejYGFa2Fg=
X-Google-Smtp-Source: APXvYqzpileWMEcnoRFiQA/fqrdITILgKhzzpD8Thzr4UAihwZX/TokLRfU2dFty2cDgsVw9z5pDDQ==
X-Received: by 2002:a1c:ab83:: with SMTP id u125mr2290752wme.131.1559222180889;
        Thu, 30 May 2019 06:16:20 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q15sm2334874wrr.19.2019.05.30.06.16.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 30 May 2019 06:16:20 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/2] Modifications needed by the NumPy interface
Date:   Thu, 30 May 2019 16:15:54 +0300
Message-Id: <20190530131556.21832-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch-set contains modifications of the build system (the "install"
part in particular) needed in order to implement a standalone version
of the NumPy data processing interface.

Yordan Karadzhov (2):
  trace-cmd: Install public interface headers
  kernel-shark: Install public interface headers

 Makefile                                | 26 ++++++++----
 kernel-shark/README                     |  4 ++
 kernel-shark/src/CMakeLists.txt         | 56 ++++++++++++++++++++++---
 kernel-shark/src/plugins/CMakeLists.txt |  3 +-
 4 files changed, 74 insertions(+), 15 deletions(-)

-- 
2.20.1

