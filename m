Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F513C04A6A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 17:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbjHHRaP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 13:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbjHHR3o (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 13:29:44 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E0E8C0AD
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 09:12:48 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-76cab6fe9c0so553681785a.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Aug 2023 09:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691511136; x=1692115936;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zzhg2LMyeKE000rALn1qsfhP9DIZBCqS827bMolOPv4=;
        b=Sa2tm2XtnLfwkgIUj7YG+Z0Q0y7dz6SZ5cv0ZZweKvzFEiEa+JKz5jupzjz0YqzM/r
         50CzCcjM2l8Mw1ApGlmgogvsmQm78FuVdzrPhSAIbfAUCG91TBfkGGdbqfhEHFGnIqc2
         BMEfPnF6u8fb7kqiyksQUVrkWCyAE2cWQ7v6fdXxPlzqrL8tCkrZdHogVQaqr6v+Ks02
         4NdKLFAS5QcPBRPQWmOAxaMihdhFxKpaSJIxZSCbSjIaiePvoSpo7L/im0Awnrm0r5rP
         79XHe0kEVlapebEqG1urYSW/MtS74DYbRUm6hqeJpR8H95rGGW+WfqEfTSBowQ2TbN3H
         OsoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691511136; x=1692115936;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zzhg2LMyeKE000rALn1qsfhP9DIZBCqS827bMolOPv4=;
        b=L6jKD96DGY6X5Oh8IsP4ZZKHBdRzDglssFgCB0/zgn+xVWPRREoScWGazWGEydQdr3
         ReG9eDtBXX/hliFieTI7gt6Jzg9eeragjx1Lc5oopvJnA/xmA3O0li7kLYhVy7/4rP3T
         gOu5YwIfe0jLI3thuH/aUfKuTm4BAo6yp9Pp2UPRAkV5VtLcQ6gGaP3c9DVelHLKLjCp
         weSbPhH5y6AMNW2DLU9HpY4ij89AI2J2zsuCev/2CF0Cv3THod/l+et+K2vVOmS9epJF
         ot/p738F9idMAgISIOGEmVaLdGznbPBqbG/eW0HpDbQ8tTDUhc+135keBjvk1OIVniG4
         7HUA==
X-Gm-Message-State: AOJu0YwAE5ODYKDWHSkRKxPqaxAlb4sbx0i2bRZj+fiJ1c0QyOqepN/Y
        VpFQbv7VCJ7Bi8OoZ96PAlvjbghp7Qo=
X-Google-Smtp-Source: AGHT+IEBoouxQRv+aEeav9yIXCPISRCujovC0aFQO+AyR8wzxv5xA1qHCGG3jOrJFi1kVVVU5ZycRQ==
X-Received: by 2002:a05:620a:31a8:b0:767:1a27:5302 with SMTP id bi40-20020a05620a31a800b007671a275302mr157674qkb.7.1691511135858;
        Tue, 08 Aug 2023 09:12:15 -0700 (PDT)
Received: from 3xKetch.hsd1.ma.comcast.net ([2601:180:8300:500::6aa8])
        by smtp.gmail.com with ESMTPSA id s7-20020a05620a030700b0076c97ae43b9sm3381540qkm.66.2023.08.08.09.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 09:12:15 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v3 0/6] histograms: Add query and insert
Date:   Tue,  8 Aug 2023 12:11:53 -0400
Message-ID: <20230808161204.5704-1-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>

Changes in v3:
 * Added traceeval_query() and traceeval_results_release().
 * Added traceeval_insert().
 * Reordered enum traceeval_data_type for logical numeric use.
 * Reordered traceeval_type fields for legibility.
 * Removed traceeval_flag's STAT as numerics will aggregate by default.
 * Declared traceeval_type before dyn function typedefs.
 * Changed dyn_release call's argument to pointer offset for legibility.
 * Changed dyn_release signature's argument order for legibility.
 * Removed traceeval_iterator since it isn't used.
 * Moved type_alloc()'s for-loop's semi-colon to a new line for legibility.
 * Made lables less verbose.
 * Updated type_alloc's error messages.
 * type_alloc() frees allocated data on error instead of traceeval_init().
 * Squashed initialize and release patches as init depends on release.
 * Capitalized first letter of error messages.
 * Added error message for clean_data() if data exists without defs.
 * Aligned all function parameters with opening parenthesis.
 * Remove compare and testing patches, beyond current scope of project.
---
v2 discussion: https://lore.kernel.org/linux-trace-devel/20230804083737.0d8f1d95@gandalf.local.home/T/#t

Stevie Alvarez (Google) (6):
  histograms: Initial histograms interface
  histograms: Add traceeval initialize and release
  histograms: Add traceeval compare
  histograms: Add traceeval query
  histograms: Add traceeval insert
  histograms: Initial unit tests

 Makefile                 |   2 +-
 include/traceeval-hist.h | 147 ++++++++
 include/traceeval-test.h |  16 +
 src/Makefile             |   1 +
 src/histograms.c         | 792 +++++++++++++++++++++++++++++++++++++++
 utest/.gitignore         |   1 +
 utest/Makefile           |  35 ++
 utest/eval-test.h        |  13 +
 utest/eval-utest.c       |  28 ++
 utest/traceeval-utest.c  | 290 ++++++++++++++
 10 files changed, 1324 insertions(+), 1 deletion(-)
 create mode 100644 include/traceeval-hist.h
 create mode 100644 include/traceeval-test.h
 create mode 100644 src/histograms.c
 create mode 100644 utest/.gitignore
 create mode 100644 utest/Makefile
 create mode 100644 utest/eval-test.h
 create mode 100644 utest/eval-utest.c
 create mode 100644 utest/traceeval-utest.c

-- 
2.41.0

