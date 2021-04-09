Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C2BC433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 04:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D110461168
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 04:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhDIE2B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 00:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhDIE2B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 00:28:01 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D55C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 21:27:48 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id n2so6515773ejy.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 21:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ekZbIb+aL25HxX2EfV8aoq1uqH7Y5TbhSjUSVV5G+n8=;
        b=qSYkYYVUIj5wI/diPEhTLEKyZAYdpe0kfxa+fMDDNAcmOvTZNdWurJxzChQuWQMKSV
         JLm0LiKW1Mwa/4Bs2D/lGgbQDArY1leKKnXpZGb0AyGjP8hNmMlzFS2ztq21+ZF1H07/
         Uq7XWDhEZ1inr/nqOhEHtxdmGW2jep9p8K7pSym91tib95nBijc2npjSzyQZMszEmiYa
         +IfmEO2qyY41/8tK3tTQFFessHFe5PobuVM8QWd1bILkxVnZKPQ0B4Xg1g2feflZM6kY
         gdLpYCBYbD8pXQ5vtMkERy0CTVSQWGMa1BkWEUmBBnU+9GCd6C2x0BfPPmRy47rZ8wmF
         PXeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ekZbIb+aL25HxX2EfV8aoq1uqH7Y5TbhSjUSVV5G+n8=;
        b=pnXPzwjc41BxFWFxAxR9vQTO/T4MjvZJjwDucWG0P+P20+tvdhqMyL/VCPHKnip/sn
         A08h93BG58ABRUUnA+lI1GtwRACFplRfHfOWBX4YlRwHuT7a9q+W7+bb/qSfx5yOju9x
         qhJLL96sxs6jgx4dOGBbGmfMTF9FEdiYMKD4WF8wUscHCbm5268Bu2CWRBkox6+nOSij
         gENV6iU8XIZv2Gm/a6KTrUhLFLQgx0SClncM2HKjbXM0CkaiKs0vMTYiJZjk2yXlc6Os
         8yzufF4g99Y0r7sxPPQ+Dx01RA4e6Q8SvOZ2r4Gb/hz8yzVv9zb6J9uqwCSjGLWPLnY7
         cyeg==
X-Gm-Message-State: AOAM530HHxQkGL0utSXBnuheT6ux8VaPmKHSdDw9Qq1GBjeFqcm/RCUQ
        PVO/fjZ88XhMDzSHNyrPnjf09FLbagCSMA==
X-Google-Smtp-Source: ABdhPJwgc4yQhChXRUe/qEEm95qRBW9QCRg0qg2nk/tVCvS4hYVd+2oIqLgqhnA0Skl3FVFaSlYrog==
X-Received: by 2002:a17:907:76ed:: with SMTP id kg13mr13614112ejc.99.1617942467683;
        Thu, 08 Apr 2021 21:27:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id cf4sm701089edb.19.2021.04.08.21.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 21:27:47 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/2] Documentation and unit tests for new trace marker APIs
Date:   Fri,  9 Apr 2021 07:27:44 +0300
Message-Id: <20210409042746.3179319-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documentation and unit tests for new trace marker APIs

v2 changes:
   Split the APIs in two groups - printing formated strings and writing binary data

Tzvetomir Stoyanov (VMware) (2):
  libtracefs: Document marker APIs
  libtracefs: Unit test for trace marker APIs

 Documentation/libtracefs-marker.txt     | 116 ++++++++++++++++++++++++
 Documentation/libtracefs-marker_raw.txt | 102 +++++++++++++++++++++
 Documentation/libtracefs.txt            |  10 ++
 utest/tracefs-utest.c                   | 116 ++++++++++++++++++++++++
 4 files changed, 344 insertions(+)
 create mode 100644 Documentation/libtracefs-marker.txt
 create mode 100644 Documentation/libtracefs-marker_raw.txt

-- 
2.30.2

