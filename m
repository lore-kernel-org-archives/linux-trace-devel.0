Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F8AC5519F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A631222227
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gIZi+PnW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgKTJnZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgKTJnY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 04:43:24 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E678BC0613CF
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:23 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id k27so11943319ejs.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L/nBj9MnpM+2MdCjTp/6f1Ru9XhG2Vn2Bi7Jtqf3M+8=;
        b=gIZi+PnWeqO3qFZTs57Bfxu8XinSZhciJzKwh5W1DgtMqKZIWU5kEDcraQNqysBRoQ
         7ohL2GmdXgRN2/7qbjHFaX0pomNwcrs0eKf5nOvxD7cg4MbJu5cG0JgnHKzT95uAT+em
         8E8lRe7AUhPZdenvEA6tu8jh9/BE65b+xXlS+P07Z4sX806IwnfutwSgGsuydKYmaamb
         FEo0LsZyBq8qY15VaTm4s9aCSnBXiBlucmWnB5aIAUNVpDOk8P7wV6J175/bgnulVsXV
         wIJdWVGffen2ODUGVrD8Mo6sLh9PfEqvHGijeS8VdO7rCdqgrahnDcXnnmiZSvaboXz1
         p6pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L/nBj9MnpM+2MdCjTp/6f1Ru9XhG2Vn2Bi7Jtqf3M+8=;
        b=knYZzPHmjxAae5VKy93zoDfaXxNEcawUkjJgCUIuZNVVnqfsAQrOvtfcdmZ5cRDeQA
         8npt17hL10mRf/FkiV47EXPvTvimRzewd/4ZfShWVfDZO3MOV8a+WGdZ5V4cDvstyA9g
         xXXJs/EO77rlnqm2Q+tV7BOPK+h2V/sqLK/XmS9t+6/oLW5bIyvs7cR71QEM8C1+2Uxq
         Y219txv0JbixmV+cbt29bZquMwTYjca0ESmkxyaFKjAFdfwAMlMPxg5ZOTfJDp4GA5pX
         2SrGalkNZ4GfAsdSo8ld8peTxXZq+ajz9kbWDEDZcE6YyYxJKBGVbuZchXjOZ9yfg9+P
         Oodw==
X-Gm-Message-State: AOAM533J/7pHhsNsaiZl4VLkpOPZxvztyb0XoeUw3Myg7ryEs15vZZBS
        4ZGjxOmRY9erBGQQXd0a74/t5sf5c7E=
X-Google-Smtp-Source: ABdhPJz56mReCEw9G7CHA6gbmwBrJUAJJwi8mWEYCVC8zOpL7MrNrwcVPvdW1a0vVTrir5nBHAOsXQ==
X-Received: by 2002:a17:906:4dc2:: with SMTP id f2mr31505870ejw.446.1605865402690;
        Fri, 20 Nov 2020 01:43:22 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id h2sm897006ejx.55.2020.11.20.01.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:43:22 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 00/20] * Start KernelShark v2 transformation
Date:   Fri, 20 Nov 2020 11:42:44 +0200
Message-Id: <20201120094304.271502-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In this patch-set we are starting the introduction of the changes
in the C API of libkshark. The goal of this transformation is to
turn KernelShark into a general purpose toolkit for analysis of
tracing data that is no longer strongly coupled to the Ftrace/trace-cmd
data format. At the end of the transformation KernelShark will be able
to merge and simultaneously visualize data from different tracers,
recorded in different data formats. It will also significantly extend
the possibilities for user customization.

This  patch-set transforms the way KernelShark processes the raw tracing
data. Later, in a consecutive patch-sets we will introduce the changes
in the visualization instruments and in the KernelShark GUI itself.

Changes is v5:
 * Only minor modifications addressing issues pointed out by Steven in
   his reviews of v4.

Changes is v4:
 * The integer data format identifier is replaced with a string value
   that gets registered by the readout plugin.

 * Plus several small modifications addressing the issues pointed out
   by Steven.


Changes is v3.
  This version contains number of small modifications addressing the
  issues pointed out by Steven in his review. However, it also contains
  the following major changes:

   * The session context (kshark_context) holds a pointer to unspecified
     data processing interface (void *interface). This will allow to
     easily introduce new versions of this interface in the future, while
     keeping the interface that we have now for backward compatibility.
     The necessary type checking when using the interface made the helper
     functions wrapping the corresponding methods of the interface
     relatively complicated, so the implementations have been moved from
     the header to the source file.

   * A more sophisticated management of the Data stream descriptors that
     can handle the case when Data streams are constantly added and
     removed has been implemented. The design for this change was
     suggested by Steven in his review.


Changes is v2:
 * Tried to address review comments for "kernel-shark: Introduce libkshark-hash"

 * The huge patch "kernel-shark: Integrate the stream definitions with
the C API" in the previous version is now split into 8 smaller patches.
The last of these 8 new patches (kernel-shark: Complete the stream
integration) is still a bit entangled. I can try to further break this
patch in future versions of the patch-set, if this is needed.


Yordan Karadzhov (VMware) (20):
  kernel-shark: Use only signed types in kshark_entry
  kernel-shark: Add stream_id to kshark_entry
  kernel-shark: Introduce libkshark-hash
  kernel-shark: Introduce Data streams
  kernel-shark: Rename static methods in libkshark
  kernel-shark: Add basic methods for Data streams
  kernel-shark: Housekeeping before implementing stream interface
  kernel-shark: Add stream interface for trace-cmd data
  kernel-shark: Start introducing KernelShark 2.0
  kernel-shark: Start using data streams
  kernel-shark: Remove dead code
  kernel-shark: Redesign the plugin interface
  kernel-shark: Complete the stream integration
  kernel-shark: Provide merging of multiple data streams
  kernel-shark: Integrate the stream definitions with data model
  kernel-shark: Use only signed types for model defs
  kernel-shark: Add ksmodel_get_bin()
  kernel-shark: Protect ksmodel_set_in_range_bining()
  kernel-shark: Add methods for time calibration
  kernel-shark: Integrate streams with libkshark-configio

 CMakeLists.txt             |   10 +-
 build/deff.h.cmake         |   14 +-
 examples/CMakeLists.txt    |   34 +-
 examples/configio.c        |   20 +-
 examples/datafilter.c      |   67 +-
 examples/datahisto.c       |   38 +-
 examples/dataload.c        |   28 +-
 examples/multibufferload.c |   53 +
 src/CMakeLists.txt         |    4 +-
 src/libkshark-collection.c |  121 +-
 src/libkshark-configio.c   | 1208 ++++++++++++++---
 src/libkshark-hash.c       |  239 ++++
 src/libkshark-model.c      |  154 ++-
 src/libkshark-model.h      |   55 +-
 src/libkshark-plugin.c     |  658 +++++++--
 src/libkshark-plugin.h     |  294 +++-
 src/libkshark-tepdata.c    | 1913 ++++++++++++++++++++++++++
 src/libkshark-tepdata.h    |  112 ++
 src/libkshark.c            | 2619 ++++++++++++++++++++----------------
 src/libkshark.h            |  704 ++++++++--
 20 files changed, 6522 insertions(+), 1823 deletions(-)
 create mode 100644 examples/multibufferload.c
 create mode 100644 src/libkshark-hash.c
 create mode 100644 src/libkshark-tepdata.c
 create mode 100644 src/libkshark-tepdata.h

-- 
2.25.1

