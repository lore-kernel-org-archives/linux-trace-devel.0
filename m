Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22AECC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Nov 2022 14:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiKPOnJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Nov 2022 09:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKPOnH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Nov 2022 09:43:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFD53C6E0
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Nov 2022 06:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668609725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XJodM6+r+1fcPquRDq7rM//m4qyURX25kdSdHnC/lDE=;
        b=FQcuIL6YryQuqoC1mQtJkQj3ZwEPoerMrd23zbAk0Ki/jQAhTjMV+I8W0KtmZUXr9/KGRD
        HiOor7gcqT1upbZlrN+OpR1hzASMGLqHauTbMLT8pxCbruvziPUXTmzXjCMm1gcAr+Piuq
        MlZhtrEA1aYw2Eb3vJs8nTRnX3WBKdY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-82-YiwG37UAO4SEe7cN-qTYyA-1; Wed, 16 Nov 2022 09:42:04 -0500
X-MC-Unique: YiwG37UAO4SEe7cN-qTYyA-1
Received: by mail-qk1-f200.google.com with SMTP id bk30-20020a05620a1a1e00b006fb2378c857so16648693qkb.18
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Nov 2022 06:42:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XJodM6+r+1fcPquRDq7rM//m4qyURX25kdSdHnC/lDE=;
        b=fZezRkidO5Da+apNeX3EjjxC5gIcCNaAj0YeI2M9RgMRSrqg2cSdS/lq7pITa3Lz0a
         s9NFHtHO+3FTDTxouqFsWVzzvpRbpq+s2xqQfENnIN/Wn6mm3RipKMiJyLQESFyJXwEk
         eZ2ysKpLHZNy9AbLWYvfpZ+hOiONXB2wG1hwrflMy+svogwldrEHwVc+HA1vD81yqBMi
         ALkEQ/ZYZjhvmUi9WvTQYWC1vSP+aWBkB2OLLFj36TcPIt2td7jjNX2p92ADHMHzeCvQ
         IQmmGq4130C0OHLakM0xSdRoMV6bq+VbF1GZRRGIOrCxH2OaT3m8pIyymeXY0+N/yUOB
         sbkg==
X-Gm-Message-State: ANoB5pkRl7TbvASVm1jdsgHmKFlhdDVrLI4+kCjnSEbDm9jezKRy7gXP
        Tj10AsMjOnyGfIbCM3ce2nTjNn/iqQuT+5VqNDRoTPdgCk7JposAL2eucusQAaPgDjpCo4K9F2C
        mu6n40zwaDcIAn71g9HmK6/qQwQeNcCMrsaY2iYMy32DbWQhGZjs5l+8MgxzsXvMoq8GwfnGjBB
        /H8yE4xWg=
X-Received: by 2002:a05:622a:4808:b0:3a5:be2:9a04 with SMTP id fb8-20020a05622a480800b003a50be29a04mr21354577qtb.402.1668609723250;
        Wed, 16 Nov 2022 06:42:03 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5bQNd3O1SZTHlQzBivIJqEni0hzy5MzPeLtuymH48i8Woo9pR4gaBnFebDQBsk9wHyjBqoOQ==
X-Received: by 2002:a05:622a:4808:b0:3a5:be2:9a04 with SMTP id fb8-20020a05622a480800b003a50be29a04mr21354552qtb.402.1668609722930;
        Wed, 16 Nov 2022 06:42:02 -0800 (PST)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id x12-20020ac8730c000000b003a57f822157sm8707793qto.90.2022.11.16.06.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 06:42:02 -0800 (PST)
From:   Valentin Schneider <vschneid@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: [PATCH v2 0/2] libtraceevent: Handling cpumask event fields
Date:   Wed, 16 Nov 2022 14:41:52 +0000
Message-Id: <20221116144154.3662923-1-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi folks,

While discussing around [1], Steve had the idea [2] of creating a "proper" type
for cpumask event fields so that userspace tooling doesn't have to guess whether
an unsigned long [] is meant to be a cpumask or not.

It takes a small amount of boiler plate to get cpumask fields on the same level
as bitmask fields, which is patch 1.

Patch 2 adds on top a nicer pretty-print output for cpumasks. I'm not massively
fond of the homegrown cpumask iterating function, but I've done my best to pit
it against corner cases.

Cheers,
Valentin

Revisions
=========

v1 -> v2
++++++++
o Rebased on top of latest libtraceevent
o Fixed s/__get_cpumask/__get_rel_cpumask/ typo

[1]: http://lore.kernel.org/r/xhsmhilkqfi7z.mognet@vschneid.remote.csb
[2]: http://lore.kernel.org/r/20221014080456.1d32b989@rorschach.local.home

Valentin Schneider (2):
  libtraceevent: Add boiler-plate code for cpumask types
  libtraceevent: Pretty-print cpumask fields as a cpulist

 include/traceevent/event-parse.h |   1 +
 src/event-parse.c                | 190 +++++++++++++++++++++++++++++++
 2 files changed, 191 insertions(+)

--
2.31.1

