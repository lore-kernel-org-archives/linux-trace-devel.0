Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A2BEC43217
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Oct 2022 15:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiJRPRD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Oct 2022 11:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiJRPRC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Oct 2022 11:17:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A13C2C91
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Oct 2022 08:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666106219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QhMmYWNZ0XlJtBc6clc0AJiYwQKCvjXfzRVIZpJIuV0=;
        b=OsTRqXhJBFavR7T5HYSfn+NLzlmWrdnVdvhO8JiCGjhqNXIrMtJYlkzBN2k3XlgJ3nsCoC
        Z7jCBI/8ZqGERXIj4yDGxI4URXevU1sNGR8iQgPyNfEjSQN/BVhXfTB6tQXV+5ie58NZuI
        mpE2wkr1Fdmvp28rtckPU9Z7taK8ufA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-655-tyqh33C-OYSXN0B9WPMalw-1; Tue, 18 Oct 2022 11:16:58 -0400
X-MC-Unique: tyqh33C-OYSXN0B9WPMalw-1
Received: by mail-qv1-f70.google.com with SMTP id ma6-20020a0562145b0600b004b49a5037aeso8042127qvb.18
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Oct 2022 08:16:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QhMmYWNZ0XlJtBc6clc0AJiYwQKCvjXfzRVIZpJIuV0=;
        b=Lh8JyZVfHAE0l4xhCswa/Vy0lyc93r+qmRyOVhHShQpxjoduYMEo+PFgrUT4i1TW8I
         8uq9bstFNOIHnv21BcPuLlAHcLEp9lmdix9LRLwtuyN4VlKlDkCRVSD5X9ltEmCpfs7Y
         hH72mhxVM2sBioBWFfzXjIsDqy6lH9JKNScTY5tR+//nvDOWZkWQ2lbjrWtFZlbwf0zm
         +lM1VdBMXpfN4iPcQe3xr7SUmlOTbb7iPoCT814sVg6vgtfx7/pAurWGPAhKBU9WRZyA
         TyadRwmnQcNcQaEwUqtFv7sDjpcUY5oWMDs1w0Yu6OSmxN0YkEeijvVJRhLy/EcICmuK
         eeAw==
X-Gm-Message-State: ACrzQf1nkf6xvctraxPA9A26tzVjiQVcSMsZoRs9klh+RP+HrRJx5iyu
        t54NuIHcncEffgoME5BXQpj+0U777uwT3fGYweLC/nSIvQ/4zD4SBC0D9zf35mgXShcGPkFJ3mL
        xBq6E32XT80S3GJ4CLI9m6NQ5QB9i0ZiGqcb/3sKRQpCyl/wYKUOLDTk6KI+QS0HcjlnELJmu/G
        I0MVW33Hk=
X-Received: by 2002:ae9:eb53:0:b0:6ee:80cb:229e with SMTP id b80-20020ae9eb53000000b006ee80cb229emr2155351qkg.37.1666106217241;
        Tue, 18 Oct 2022 08:16:57 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4YCPgaH9xOutwfI8TBMeM4k5IcdLDka4ZCt4tMxtjmedBzbDzTna/ID9XesLLoWrODRnN2+g==
X-Received: by 2002:ae9:eb53:0:b0:6ee:80cb:229e with SMTP id b80-20020ae9eb53000000b006ee80cb229emr2155319qkg.37.1666106216942;
        Tue, 18 Oct 2022 08:16:56 -0700 (PDT)
Received: from vschneid.remote.csb ([149.71.65.94])
        by smtp.gmail.com with ESMTPSA id s23-20020a05622a1a9700b003988b3d5280sm2159646qtc.70.2022.10.18.08.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 08:16:56 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: [PATCH 0/2] libtraceevent: Handling cpumask event fields
Date:   Tue, 18 Oct 2022 16:16:28 +0100
Message-Id: <20221018151630.1513535-1-vschneid@redhat.com>
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

