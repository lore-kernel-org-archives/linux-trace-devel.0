Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1683AC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 08:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbiAXI4t (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 03:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242515AbiAXI4t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 03:56:49 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8ACC06173D
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:48 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id r14so1591796wrc.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BblhJ8D4hno5ErnqAb5iLjdr+B04LXbWo8Ga1SpycLI=;
        b=VHOB6nkHzpTDUzoWvYvDiGCYRc/7Q1k/dB51eZ6GOpw8gVxPXP7PUHF/vEtBGqRP+w
         /uOiNtGgT1xcoU3y97w3eRQppfeM+u+uEEYLcwxQ5tJUbec+9XsqpdqHZcw0bU2+azW8
         hIG5WhsYt0lyrdbnUuCQFaGktKkYiA01x2giY/gxSPvUt/ZMDBYE9F4KW8yIT8rqeJ3z
         hrBfSOLP25OfTHJcDVeuViS5hq9eBcj/AQG77wz8372tPCBbwoCaIDB/LcpzyBiiByaX
         +hqEYmnRU30n84tx+MKpISLw8+liHagh6yYbdCWlklI88V7rwqhE17Jne1akxZTBUWgJ
         KVmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BblhJ8D4hno5ErnqAb5iLjdr+B04LXbWo8Ga1SpycLI=;
        b=LfV/4HxLrmpKwHpc3/D2NdZBEZZwPfx76Rgjo8Qf/22v/zojMlbGrMXNhC8XdljtKr
         Tb3R78pLifmELCKWrxFAkTDs1sHgHCjPW3Kpp4oAUSwFZrZ+IE9OR8usD/DpkDFUwiHo
         T0Yr05Va5hnEF8CJSW3BVpGondIRp1doC1woLg5VYEIxcGeuVBkFNxgvFgJCnsclRcra
         SS6K/quDWMbd+pRGV/x16+/oFmKV9Zj9aGx0303KQCQ51fY0zTqYuEjidP90f0HZDHBy
         ZZvuSKhup9ODs07ZCEHcT94K8Uy7Zj6IVrJkBTRH07uVjPKINaglf6LvmQEmXqxZOw5q
         xQjw==
X-Gm-Message-State: AOAM531GsXvXtp/kEEYqrBeqNR+pIJMRMngW8vPAOOhF7LezaWmmbvYZ
        6ufQK7BhxMzA6TBuG/0oesog5Z0V/24=
X-Google-Smtp-Source: ABdhPJx9iTgylwqNqw1c/qwjhBmxmyIIuIc0JOJnOm1aH1K0ceQHimXMSGWCw2pQef5LVJq6lPpdew==
X-Received: by 2002:a5d:55c6:: with SMTP id i6mr10368522wrw.641.1643014607246;
        Mon, 24 Jan 2022 00:56:47 -0800 (PST)
Received: from crow.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id f14sm14828091wri.44.2022.01.24.00.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 00:56:46 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 00/10] trace-cruncher: Synthetic events
Date:   Mon, 24 Jan 2022 10:56:15 +0200
Message-Id: <20220124085625.92297-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adding support for synthetic events. Only the low level wrapper of
the libtracefs APIs is added here.

Yordan Karadzhov (VMware) (10):
  trace-cruncher: Define Python type for synthetic events
  trace-cruncher: APIs for adding start/end fields to synth. event
  trace-cruncher: APIs for adding arithmetic fields to synth. events
  trace-cruncher: APIs for registering/unregistering synth. events
  trace-cruncher: APIs for enabling synth. events
  trace-cryncher: Add static methods for manipulating filters
  trace-cruncher: APIs for filtering synth. events
  trace-cruncher: API to show descriptor of the synth. event
  trace-cruncher: Add synthetic event example
  trace-cruncher: Add synth. events tests

 examples/synth.py                             |  43 ++
 src/ftracepy-utils.c                          | 513 ++++++++++++++++--
 src/ftracepy-utils.h                          |  47 ++
 src/ftracepy.c                                |  92 ++++
 .../tests/1_unit/test_01_ftracepy_unit.py     |  86 +++
 5 files changed, 735 insertions(+), 46 deletions(-)
 create mode 100755 examples/synth.py

-- 
2.32.0

