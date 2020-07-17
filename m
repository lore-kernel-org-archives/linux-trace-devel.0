Return-Path: <SRS0=fBth=A4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C87CFC433DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 07:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 972A22071A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 07:57:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hKjzX6Xs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgGQH5q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 03:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgGQH5p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 03:57:45 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D6CC061755
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jul 2020 00:57:45 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a21so9793805ejj.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jul 2020 00:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JcWeVdFUVIdm3qGiHtRLhU7TjbPEgRhpRVuBizbmVB8=;
        b=hKjzX6XsIZtoeHiPGGAES8w/rOIqDS1bjp9KvDxvO/lP71Zswgmowjltt8bN3ORDai
         aAyRYObeiWiZBkRyGZMsET8Y7TJhrTyitkW8/m7JjH9pUuY88Rn0mJy+QzpUeWLCrGh0
         oSl6bS4U1y28wiJkiHKQN9Z3IfCPjcBCwMCOTPrYJOj/hLkbVQ2yfeYNj4D415Yxg/gm
         ydAKEb+T/eVwWnpGQEuiKYb/obMxHxPUSwkYa/g1dtEV5wntZKptaf7MWhNADKtqFlSK
         3K15g7yMgQUeVb/94DK6+rJxiVRPOYrdFLp/c3Igk51tz10eLiuOm+aJs5DD/1w0U0fI
         ZHSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JcWeVdFUVIdm3qGiHtRLhU7TjbPEgRhpRVuBizbmVB8=;
        b=aF0LcaVeYEJmPpHxaFxjltaV4LpT0l+Hsa2P9VQOAaOk+TNG67FItcgQkM0SPmEJO8
         QX0gOk0OAKy6UObz84gLH5sTHZAD2PYCo0Y4eN4xg8oGsQpVzJoWmsUu8kGQJQJFF5jw
         Lmcu8Cya8JSiI2re9WPACIQrk9R9RjHQQP5IWLXrE5voVGhIGmejH3EAbDC96ZwlgPP0
         cP/07AvN0XPYoUCGIlBoQuUB8j9+V9YLRxi1FPAMEDVgIO1FUJvKWloLSV1JjvhTaCx2
         96/lbONQ8hJ2B/mHafTWaT9adqhe7T7SUUKo32gvmnJu+/RWjJY1bOrB6jtgtsyE+AxE
         UpXA==
X-Gm-Message-State: AOAM533IdXJJYdO+LXMOZeEuR7dgPw4p/oTK60vEKwkPjQ9nSCfQGQar
        eE5MywB9yxlQoxGILwV8/YjzKJpeqE8=
X-Google-Smtp-Source: ABdhPJyi0s9ikG4HIxBTbSFEaHeNnvSIL1XJOUqj0sghkTeyFQbAXXNJCo2PS2JCtRL8St+etbNc7A==
X-Received: by 2002:a17:906:d116:: with SMTP id b22mr7218218ejz.250.1594972663405;
        Fri, 17 Jul 2020 00:57:43 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c15sm7901997edm.47.2020.07.17.00.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 00:57:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] trace-cmd documentation updates
Date:   Fri, 17 Jul 2020 10:57:39 +0300
Message-Id: <20200717075741.74775-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented "trace-cmd report --cpu ..." option
Added new man page for trace-cmd clear subcommand

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Man page of trace-cmd clear subcommand
  trace-cmd: Document "trace-cmd report --cpu ..." option

 Documentation/trace-cmd-clear.1.txt  | 40 ++++++++++++++++++++++++++++
 Documentation/trace-cmd-report.1.txt |  9 +++++++
 tracecmd/trace-usage.c               |  2 ++
 3 files changed, 51 insertions(+)
 create mode 100644 Documentation/trace-cmd-clear.1.txt

-- 
2.26.2

