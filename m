Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB28C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbhLJLLm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhLJLLl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:11:41 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC869C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:08:06 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id l25so28957342eda.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+eXvFASvHeeN7ZIAsp7Du5tP3D8EwVnBzjCI5r/YG80=;
        b=RhgYi5orPN798lKsxQaraTPqw/m0lGvy+d6L8k1yO3K6T+zjJU32Rr6FgImwNFQE7c
         fPa8+VzBqMUcdULYEVwlvYQ1fnP/5vY3PVmuCKCF5boaLKTsC+jra8Znm4al0stWVIW/
         qKMVoJqXLLR+3UmKwdBIVCF7KCZchkxhjzYGMrl7gESdEbrB859eVmEX/GLv0FkHAsXF
         Lx5xQSt/styuaHNjpk+4Dm/PjoN9BJwv35/VJsQxGuTs3DoE252RBhesmDvBoEYYovvp
         +sRuu5VtzPw+9BA5SN70JGGMFT78FBUmi0s0Pe2nrpxJJ2BqYdUh/LkpjqzXJXLCpZaP
         eMpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+eXvFASvHeeN7ZIAsp7Du5tP3D8EwVnBzjCI5r/YG80=;
        b=r3aZaZEYawk4BhDDm5qjbUGzEqfymuK+r+/wRMrfHUd6V3MGMHpjSfqvBEZxtXTjrC
         O7o1IUHkH88ERn9QdCpJRbfpMrwRaY1T+sFQYgR5C+E/D7riqCbvq7dJKHtYsibCeQBf
         PckDYs+U5Hkl9VeyHFilNqgBVcKvxSpwOrWotIs2F2R2aVZ6I+1heTGjpXlNS4hOccBe
         tPwdUnJ+AsalqFHqFGHEzKAyiZXe/MceOoKoObb1WeqeFZiaDrviqWDeHequTxz/5y6j
         yTGQmvwy3yF69O7yCnb0FIxMIZsZaiw9THZV1iMyY+18wTwu3hA6QJxfNrmT/gJ5cgZh
         wTKQ==
X-Gm-Message-State: AOAM531l4dWiXyuFeJWDYkyaDbv13fhz5NFeoWdL3DAgpmv4irD40uKh
        Jdr/i0g4SaHBILMemofpRqm0tZLy/BI=
X-Google-Smtp-Source: ABdhPJxt+dxfJ4tv7lFr3TLkGxMiAC2YkTPSwL80W1gCyIAVxRnflf5pcAjgFT/UsRreQPOD1h5tlQ==
X-Received: by 2002:a05:6402:1a4f:: with SMTP id bf15mr37997343edb.260.1639134485322;
        Fri, 10 Dec 2021 03:08:05 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j14sm1287172edw.96.2021.12.10.03.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:08:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 0/2] Get trace buffer page size from kernel
Date:   Fri, 10 Dec 2021 13:08:01 +0200
Message-Id: <20211210110803.99188-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace buffer page size is equal to the system memory page size in
the current ftrace implementation, but this may change in the future.
The newly introduced traceevent library API should be used to get the
real trace buffer page size, bases on the information from the
"events/header_page" ftrace file.

This patch set depends on:
 "[PATCH] libtraceevent: A new API for trace page size"
  https://lore.kernel.org/linux-trace-devel/20211126034606.190816-1-tz.stoyanov@gmail.com/
 "[PATCH v6 00/11] trace-cmd dump - v7 update"
 https://lore.kernel.org/linux-trace-devel/20211210110511.98856-1-tz.stoyanov@gmail.com/

v4 changes
 - Rebased on top of the latest master.
v3 changes
 - Rebased on top of the latest master.
v2 changes:
 - libtraceevent API is renamed, use the new version.
 - Rewrote get_trace_page_size() to use libtracefs APIs.
 - Cleanups in "trace-cmd dump" output, related to buffer page size print.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd library: Use the real trace buffer page size
  trace-cmd library: Introduce buffer page size per instance

 lib/trace-cmd/include/trace-cmd-local.h |  4 +-
 lib/trace-cmd/trace-input.c             | 11 +++-
 lib/trace-cmd/trace-output.c            | 71 ++++++++++++++++++++-----
 tracecmd/trace-dump.c                   |  9 +++-
 4 files changed, 77 insertions(+), 18 deletions(-)

-- 
2.33.1

