Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF64CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 16:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiBXQhq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 11:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiBXQhq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 11:37:46 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141C23389B;
        Thu, 24 Feb 2022 08:37:15 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id s1so3615578edd.13;
        Thu, 24 Feb 2022 08:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wWHTaFwTiuGpPOgcIbW3oNXqJeD7YofApiSAOaPy0zU=;
        b=ocdddwYqms6ThsOt8yUB8Kby2QmhgZS/25CVwCxAAaubvkxplOIwx9k8PtXT5J1uYP
         ciZEMVmj4HPPjG0Em7HD0jCl6VjEp7p6CNfHgtXtc1SCLwBq4RPv9ppNDTrEbTMwyoLX
         /Bj/rGkBr4gKovriBygG5SGMMtn/G28Xz0F1A+sZqhVCiUFPaHTkPmkjvlRGD/h9RDDy
         OQiEAy5Fb/FqIYmZHolQBCYBBOqgSRHCLsSoDvC5nEAFXuV11Iizb9M239ksky01jkG+
         1YpyQ7qHHNnEXieU0DuURLc7xeErcSVmMMtpp7GCEv89LKwC9ucg7rgACzuvoYHvQ3FH
         IZLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wWHTaFwTiuGpPOgcIbW3oNXqJeD7YofApiSAOaPy0zU=;
        b=0hI0OTAs0wnYcD0K3cKFNnEcKxLbmDUiaodSIQYn4P2IVqw+WbYjDWFcic0UUfyOfq
         pUejD3QjZceG+HbHTdj3XMVsjZwUrrGXUtFa2vSqlJR3u7nKnwgxQt3zeulMl57x0In+
         GZWk9PvLuOIBhoPEGdqJ7+CYQaYL3zHJ3s2XZcA/BKfu926A9lxrio0NZVCoqaUyCEx7
         ZfWm0X2wFiQ5PGxAMPpMSX6zUV+rrDVMv4ZQ6VEDCPsveiZu9MdCvXhm7qSKGTFqzW/M
         SkwHjkdXOVAF74TERlYRycQzJXRuxth4ZzLvT9gWdXo6eGPG6rwN00KrFRhXLAEh8aDC
         Zhtw==
X-Gm-Message-State: AOAM531UvGm5lJyizXKF6DqrYY+z4uObIC2CMrZNy5DL8btL74tOm+Ld
        v9wVNJc8/nsQK4dDh6+HUoM=
X-Google-Smtp-Source: ABdhPJzKbKSZ3CjUjv9K5g58bekZPGbbtiIunLjij7R02uOwRGwjBdm4DwGOPrmHYxBSwPKkDWdhKw==
X-Received: by 2002:a50:8d1e:0:b0:413:492b:2c86 with SMTP id s30-20020a508d1e000000b00413492b2c86mr3118807eds.140.1645720634422;
        Thu, 24 Feb 2022 08:37:14 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o10sm1579690ejj.6.2022.02.24.08.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 08:37:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com, acme@kernel.org, olsajiri@gmail.com,
        irogers@google.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [RFC PATCH 0/3] trace-cruncher: Initial support for perf
Date:   Thu, 24 Feb 2022 18:37:08 +0200
Message-Id: <20220224163711.185308-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Two major functionalities are introduced by this patch set:
 - VMA <-> function name resolving, using bfd library.
 - Support for Linux kernel perf framework, using perf library.

This is still a work in progress. Depends on this patch, not yet merged:
https://lore.kernel.org/linux-perf-users/20220221102628.43904-1-tz.stoyanov@gmail.com/

Tzvetomir Stoyanov (VMware) (3):
  trace-cruncher: Logic for resolving address to function name
  trace-cruncher: Support for perf
  trace-cruncher: perf example

 examples/perf_sampling.py |  51 +++
 setup.py                  |   9 +-
 src/perfpy-utils.c        | 699 ++++++++++++++++++++++++++++++
 src/perfpy-utils.h        |  41 ++
 src/perfpy.c              | 141 ++++++
 src/trace-obj-debug.c     | 873 ++++++++++++++++++++++++++++++++++++++
 src/trace-obj-debug.h     |  52 +++
 7 files changed, 1865 insertions(+), 1 deletion(-)
 create mode 100755 examples/perf_sampling.py
 create mode 100644 src/perfpy-utils.c
 create mode 100644 src/perfpy-utils.h
 create mode 100644 src/perfpy.c
 create mode 100644 src/trace-obj-debug.c
 create mode 100644 src/trace-obj-debug.h

-- 
2.34.1

