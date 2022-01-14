Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A179C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jan 2022 10:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237489AbiANKAE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jan 2022 05:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240196AbiANJ7y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jan 2022 04:59:54 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC8EC06161C
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 01:59:54 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id k15so32920724edk.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 01:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HSLMQpjVBgqfR9orGRhLHNceAomzTFbPKxv6rphcWtI=;
        b=FJ2MI/HWeXwQr6gdI2AAs0ulap9phlsiGyhoxG9cY7cpHU3loZ1AeqO3qT5arZe1Zi
         aX4Pay5pDQuPNmtk/eJZJBD3CFPxAjoDA52KZhYrE8JZJ7v1/PfcilNPO+tx39rOVm7T
         hNKYtS1Oe/l+DLpbUF+2FyYwG7Ts/q3GoNXER5ENkmbD0abvUhJugr2UujbNkufZ4kKh
         p0iMLNmE37+/z3XRDpxKkw7mnY7HErmqF1M4H2eWTKn5GxyQmkRGa4L51iOAePUwkIzF
         FCkIczyFkWThBcEfjS+WdSnA74+cVfSSk7v5jKfisy1KUI+8cYxzyR0NBUZWvHIHiy7T
         TEMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HSLMQpjVBgqfR9orGRhLHNceAomzTFbPKxv6rphcWtI=;
        b=sEFkYvBe+q0AeXsJhlWjskjD4xex0jefxUO/CnwDEsgclhru7lXbRYnWiT2PqTJscD
         NoM4dh7zQ+KVVUH5Gu68BMKnFFka2vcmbH5A7l43LLit5eKeJjUJUJiw2emvjeejf70D
         s7ijmztDaryuvUzmlRduiz7BjWI4DFwVjn40uGJSU6wm/djflcO2caVpTIKGY9oDdw1y
         5Et++mHtOdHaxegYX/Cj4S2hQ1G0niHFCu18Cp3vVawNBDa1kyXUQ95QpU4NQ3CAdHCY
         44a9eDBdHjIQO6ZWFoEv/fBglsopt8jKWk7i+50kjVeMTSrvIk1Nh1IoYUt7k0tS8eb5
         7Mxg==
X-Gm-Message-State: AOAM531v39xQi916ojD8wXsHB8yMCnckR0JurhiQHXEIHbIAq4VAUFCT
        7eK0LMAik9WkwitCAeTtmYYH5pR+Nsw=
X-Google-Smtp-Source: ABdhPJy34qNf/vJhu4YCVyu9weiC46mevY6TrxImCnR5LeESNkUK7QR3Bs3CGOmYwpQ0KzrVex80PA==
X-Received: by 2002:a17:906:6a0c:: with SMTP id qw12mr6974765ejc.620.1642154393020;
        Fri, 14 Jan 2022 01:59:53 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 24sm1675810eje.158.2022.01.14.01.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 01:59:52 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Man pages updates and fixes
Date:   Fri, 14 Jan 2022 11:59:48 +0200
Message-Id: <20220114095950.41334-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Unified the man pages style and updated the main man page.

Tzvetomir Stoyanov (VMware) (2):
  libtracefs: Unify man pages style
  libtracefs: Update main man page

 Documentation/libtracefs-error.txt            |   2 +-
 Documentation/libtracefs-events-tep.txt       |  18 +--
 Documentation/libtracefs-events.txt           |  39 ++---
 Documentation/libtracefs-files.txt            |  20 +--
 Documentation/libtracefs-filter.txt           |  12 +-
 Documentation/libtracefs-function-filter.txt  |   8 +-
 Documentation/libtracefs-hist-cont.txt        |  20 +--
 Documentation/libtracefs-hist.txt             | 127 ++++++++--------
 .../libtracefs-instances-affinity.txt         |  14 +-
 .../libtracefs-instances-file-manip.txt       |  26 ++--
 Documentation/libtracefs-instances-files.txt  |  14 +-
 Documentation/libtracefs-instances-manage.txt |  28 ++--
 Documentation/libtracefs-instances-utils.txt  |  16 +-
 Documentation/libtracefs-log.txt              |   4 +-
 Documentation/libtracefs-marker.txt           |  12 +-
 Documentation/libtracefs-marker_raw.txt       |  12 +-
 Documentation/libtracefs-option-get.txt       |  18 +--
 Documentation/libtracefs-option-misc.txt      |  10 +-
 Documentation/libtracefs-sql.txt              |   8 +-
 Documentation/libtracefs-stream.txt           |  14 +-
 Documentation/libtracefs-synth.txt            |  84 +++++------
 Documentation/libtracefs-synth2.txt           |  55 +++----
 Documentation/libtracefs-traceon.txt          |  18 +--
 Documentation/libtracefs-tracer.txt           |   4 +-
 Documentation/libtracefs-utils.txt            |  16 +-
 Documentation/libtracefs.txt                  | 140 +++++++++++++++++-
 26 files changed, 441 insertions(+), 298 deletions(-)

-- 
2.34.1

