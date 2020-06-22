Return-Path: <SRS0=YrCp=AD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94625C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65FB420738
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:36:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NsMbqmqj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgFVOg4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 10:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbgFVOgz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 10:36:55 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F046C061573
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 07:36:55 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id e15so3428162edr.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 07:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z3nPEXIYRlp8UMT1NEuvKHPFZJG659vQMRnwYcHkHug=;
        b=NsMbqmqj8BAaJn64rzaNEx3JcRy2BznLX3eRJQGq+boFh+fobZ5NYiZFlqqhgbg0yv
         T1DxbqLNJalwwEkfulW4Rt8vOmiBwDG6e/TPo9CNnMhOuvtHA+aH6tFECyzbBIJepfyM
         biLKMyarWgY0BOo1TLKP5i9W6kGfUb66sw0lUd2gYLVjCxZv8tf3bYf7xnqFl0lvPgXB
         xAcEtTy7Clsg4BQwL2paD8sT8ypk83RbdQLfcXSv+xZNNzcY9uxJVFxFsxllRb0OABBs
         wKmggy5DWDiKojZgUMS+SJtPf9aMvEqezrwS564SbPpuSKaKPV2SiZRwvcRytLj0hHM+
         PGVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z3nPEXIYRlp8UMT1NEuvKHPFZJG659vQMRnwYcHkHug=;
        b=o9EWqu+m0PkLriX0z1W0M9oAd0NPfwM+9LajAN8xlshpvY2AGdWuNdRUgaIVveZEax
         1kgZWKLWqNO+NmaGRDB3Oe0uPMOFwbQXpdB2vjY2tzqy9BawQ//HPi+rUmVcRtyOQ/U7
         cmzdKaZhd1h2ecJW/pjlQlxXHASzvTXn9mSmFVuPNAz4ahYfnwAsT3UUt7ju746X3Ebz
         bofFwpQiaXhpnYXa0d49yXZT57yseCb2WXUhMQOfBduyrfR9kyIHGjqdsLU2pswmXCF2
         BT8k6clfTkyeRvo8ERHSY8DOZcHARorgmuHYYXaBdmtwsw1L/KW3EzjIgBoLAIugfev6
         oESw==
X-Gm-Message-State: AOAM533PPWCgB1e3ykLhH09NCW6yo7tJrfbyGN0IF4MGHs6hOG6wz+1b
        ENiCbrqrJbGTWXrAkv4DqjE=
X-Google-Smtp-Source: ABdhPJyeLi1zybjWnkg+A+tmWJMRII8WHfKzo+jqbmMfXflbZp9TczVE7iceyfycGOHgnsvmWZGAXA==
X-Received: by 2002:a50:8e1e:: with SMTP id 30mr6725986edw.283.1592836614028;
        Mon, 22 Jun 2020 07:36:54 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z1sm11810259eji.92.2020.06.22.07.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 07:36:53 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/4]Synchronize libtraceevent with kernel tree
Date:   Mon, 22 Jun 2020 17:36:47 +0300
Message-Id: <20200622143651.179674-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Backported few traceevent library patches from kernel's tools/lib/traceevent
v2 changes:
 - Signed off patches by me ( Tzvetomir Stoyanov (VMware) )

He Zhe (1):
  trace-cmd traceevent: Take care of return value of asprintf

Hewenliang (1):
  trace-cmd traceevent: Fix memory leakage in filter_event

Paolo Bonzini (1):
  trace-cmd traceevent: update KVM plugin

Zou Wei (1):
  trace-cmd libtraceevent: Remove unneeded semicolon

 lib/traceevent/kbuffer-parse.c      |  2 +-
 lib/traceevent/parse-filter.c       | 33 +++++++++++++++++++----------
 lib/traceevent/plugins/plugin_kvm.c | 25 +++++++++++++++-------
 3 files changed, 40 insertions(+), 20 deletions(-)

-- 
2.26.2

