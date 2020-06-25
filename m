Return-Path: <SRS0=vwyE=AG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B51C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C306020702
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:04:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JMuzcOS6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390815AbgFYKEp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 06:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389860AbgFYKEp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 06:04:45 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2ACC061573
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:04:44 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 17so5303584wmo.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SKdSX6Y0E8PONGaB9WNw0DjsI54W1zaSDKDW0pz6Ljo=;
        b=JMuzcOS6H5h05cQxTMOFWda0jcwd14iHdTok0Ys4gxachv++upnr4/AEdHQ4wsOnwE
         FML18VYqW7WGeo8eK9THnnvYIRZb2mIr4os1TJfKzK9I8m5n0GU1mDQ5vOV77ZyemoRp
         HBHdak2lviyysSTYErhaSbKLvXdPquxU8zwfiFaizPFh7RmQUB3ggnBiJ/+XEaVt/a0K
         YbHjHkE+txSl3N/+Vrz+WFznCRlKFzxF2zvEzEQTE7vnlJqtKjlPOnCme4Hx8/nWKLI/
         QhLdCIRNdVW1BL/ZAjKUqqGR/savo+pwWZJ6QUhHVAIAPPL0aEGbypFFoNJDzxuzwMZk
         J7Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SKdSX6Y0E8PONGaB9WNw0DjsI54W1zaSDKDW0pz6Ljo=;
        b=IpCnzDf3rv0jY8JJcor93c8OzyQsZS8CoSviYKsNbxSdxzPxsxCTIiZdcuLrrQM94D
         24/HhPNzB2x90HnwOfZd37wEVRwhfzeP03Xf+SlbiArjeQYi2YT7kTQqHuz0Qb5+XlIr
         kI+Yeybzcl049i1TWzduxE/yq5Sfm+OtE4DL7UmmUbk9aQ2VBwuNl4kE5N51Stk3MylD
         zZIWAl488peE1525EuvlrdloO1oCo7Xqhn8IfFfcqqazeaOgFyFUsaz3F/NXaxzOjHuy
         X9RVuBCE/TH8uOOa3slh4f+VkZjMGjCmdfFstHfhKYYSxDHlGcj6SxDDc+sB9pAVWjKQ
         5WlA==
X-Gm-Message-State: AOAM530rMeyXcmv7yF0xJGU3AxW2JPiWXZfqJjkdK4v7vjWdyMShsqvs
        fLOJWNhRl19sfJSIo0fVvTSZbpnPbzk=
X-Google-Smtp-Source: ABdhPJyPBOGJRULf1g02iKWFxqe+VqXE9sErWOX+Cc/2Awkvcg1VX0AdtXdA3YvS1xVKv6dhZ4meZg==
X-Received: by 2002:a1c:4b0f:: with SMTP id y15mr2632059wma.83.1593079482461;
        Thu, 25 Jun 2020 03:04:42 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm7519008wmf.33.2020.06.25.03.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 03:04:41 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] Synchronize libtraceevent with kernel tree
Date:   Thu, 25 Jun 2020 13:04:37 +0300
Message-Id: <20200625100440.365196-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

More backported traceevent library patches from kernel's tools/lib/traceevent

Steven Rostedt (VMware) (3):
  trace-cmd traceevent: Add append() function helper for appending
    strings
  trace-cmd traceevent: Handle __attribute__((user)) in field names
  trace-cmd traceevent: Add handler for __builtin_expect()

 lib/traceevent/event-parse.c | 168 +++++++++++++++++++++++------------
 1 file changed, 111 insertions(+), 57 deletions(-)

-- 
2.26.2

