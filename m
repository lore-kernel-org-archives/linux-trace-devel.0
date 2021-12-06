Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF0BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Dec 2021 15:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356274AbhLFPRw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Dec 2021 10:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358205AbhLFPQ3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Dec 2021 10:16:29 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC05C07E5C7
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Dec 2021 07:09:09 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id q3so23075830wru.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Dec 2021 07:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B9CFhPVMPwj8QsVRkkmkqjI9obtDB5Meosvpnq/ZvUI=;
        b=BVFHRubK3GJmDaXHJoj7YTrjQury+o6KK5kBQNmCiekqEYXzFSOHhqdiTXuyudmHG5
         jdfuQ5/2L8GSU0KypaBIGCNztyRbU98g8Z8EEfJniZZ8XqEaLcHkN4mX9LP5JRn7Kqb5
         ueZS5gvKsSxgE6yslBIRNP8WzxEN+NUPnZGlFqmgpHgRvCS8z+th39y99BEpewu/DYbB
         72bo4YA+K8HlSwkWi1+u8Oo2WMbFqBqtsPNkV/xD5dKW7UmzWwQ+9jtkbfjZdOv/aoxN
         ytBn+6NDbRdOzu/LU623+5TQ7weCgxagN/ew9ZTz9juRu7kiD3ZCWrRs01zSWSctf/uc
         h9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B9CFhPVMPwj8QsVRkkmkqjI9obtDB5Meosvpnq/ZvUI=;
        b=OpIIQl/kF8XNpN3ujAk9NVKZ55/4wmqfrPu7vDFZgw2mZ9EpkGqoYhtImeBDmV3qHF
         TmBPXZ1Jx2ePhq2yUO2H1S/hLpk4dAB3LSGDqeI9zGCwkxdZ6Y+4Z2zwlsmjtJWYSfN0
         95E3T0c3kDE1yCqoCX0dthKhaeeiSkF7ETPg3Jnb54qnvPuM2XLxa13gDLNMyH1GInhf
         sMczs6QoSDjQ0OGJV2+fk6JAIqG+rlFnVPMbmTgPTSMNeXuWk0n4PRPV+UAq8bdhWKTy
         bv3P4YnExrauT4q/hO+d92LBQn95jbmd2E+Y/XEUxGpPrJkwJOyDlqGBPaCw2YsiwnYW
         dilw==
X-Gm-Message-State: AOAM531p30XKCD3kbuT3ddNKPVX17Wi+UyUvwmsSA1HNZBy8w0Z5yczC
        CLaVaETMOQQLjB7f+k2DHZA4kJH3+KI=
X-Google-Smtp-Source: ABdhPJwBURpuHlnyeWoTpA7pdgHnjiaJBmrOTo1/PLlzbWiAAtdgA1860bAwOfbw0XEozxe8uU1PhA==
X-Received: by 2002:adf:d1cd:: with SMTP id b13mr42959422wrd.323.1638803347883;
        Mon, 06 Dec 2021 07:09:07 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id d6sm11782668wrn.53.2021.12.06.07.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 07:09:07 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org, rostedt@goodmis.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/3] libtracefs: APIs for inspecting of hist and synth objects
Date:   Mon,  6 Dec 2021 17:08:52 +0200
Message-Id: <20211206150855.361202-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I hope this minor changes can go in before tagging new version.

Thanks!
Yordan

Yordan Karadzhov (VMware) (3):
  libtracefs: New API for getting the raw format of a histogram
  libtracefs: Rename the 'tracefs_get_hist_*()' APIs
  libtracefs: Add new API for getting synth event name WiP

 Documentation/libtracefs-hist.txt   | 24 +++++++++-
 Documentation/libtracefs-synth2.txt |  8 +++-
 include/tracefs.h                   | 10 +++--
 src/tracefs-hist.c                  | 69 +++++++++++++++++++++++++++--
 4 files changed, 101 insertions(+), 10 deletions(-)

-- 
2.32.0

