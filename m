Return-Path: <SRS0=Cbf5=BV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B887EC433DF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Aug 2020 22:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73340205CB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Aug 2020 22:36:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PzZ1WQuy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgHKWgD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 Aug 2020 18:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgHKWgD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Aug 2020 18:36:03 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AC7C06174A;
        Tue, 11 Aug 2020 15:36:02 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id r11so8374108pfl.11;
        Tue, 11 Aug 2020 15:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=XPIMo4AQhxooaHLxut+faZ6DucMzOmbgNwtotOPEbLc=;
        b=PzZ1WQuyxE9pprMaOjgqekvKri9p/eiZsaQg4gKOeeDGSy8hUbpELq/pOFrIxVI2rb
         eru0PcoOVWFIk5FuvIycFoRujg8Ao1ML6rp+tAq7iSn1pILMPxtq31HU/ISj35W2oX1E
         UNl2329ENWO8ADytXxnCFqRGe1tWPk+ARMJEJa6p/F6stvByRoI0GALUaxBv4jdLf28L
         L8CVpE+IAuhit07UskzZKa9shmJAVd6S0tE2CbLLNx9pVurM7lKknPbRixxStY7uZw9H
         tcjIcEZnfDuuNvpek3ceN4mtnAfVIIsWIoIBfl4m6qthf5r/Jgp1lthrFNI8RaY2VIuX
         bjHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=XPIMo4AQhxooaHLxut+faZ6DucMzOmbgNwtotOPEbLc=;
        b=fk7vjsyn+vFjIKymXNTfpXdjnv23wBvUEnqf8G9+xYs5oXLFNFEET34aUhR5lSjQhz
         Yj7R0n3F1GymAixKwHrD29W5vm8iKQ3IQB6qlc8aaWjmamg9HLI22pBGd8DBMKWJIUHF
         By9Z/kID0P0dtNqT9U1VfvdJ4Qk5AL2eF3/7NGdQmkcKG8C72fBwgLqiKVKg4M7Az7P5
         KSRun3j+dycZ4+/vcxnT2jCQNBm4h5GyNo8AZR7eC55ASWJH+RRwFBDlSzEwFHxZBhft
         FNYu5fHWtSM7s8XvaGO2AFhVbsf4UAT0drHcZYPuHCUCETXQkHniSRIrK7jo6w4xOBDg
         N0Bg==
X-Gm-Message-State: AOAM532e94voNS6o9oMXyEVDd3ixgWfPYPUvK4b/6IqIrJYCq/sXQ6Qo
        22Mt3MnF157wfM7qaCdjXi9XOSJdCrONU4FMEHbBqShKRl4=
X-Google-Smtp-Source: ABdhPJwbRC583CzaXDGwpyK7ToaNlKMk1NglW4FNv0XAwD+LL+Rq/siS/xYytMKZr28dKrb19fJ8ScVXISLF8PvVrSk=
X-Received: by 2002:a63:584c:: with SMTP id i12mr2604851pgm.313.1597185360721;
 Tue, 11 Aug 2020 15:36:00 -0700 (PDT)
MIME-Version: 1.0
From:   Ahmed Zaki <anzaki@gmail.com>
Date:   Wed, 12 Aug 2020 00:35:24 +0200
Message-ID: <CANczwAGy1tQe1yhgnwhfStGCfh4iFvMei_AqPEvTbLmmPBWatg@mail.gmail.com>
Subject: function_profile_enabled not showing Time info
To:     inux-trace-users@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     ahmed nader <anzaki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hello,

I am trying to use function_profile_enabled on a MIPS machine but only
the HITS column is showing numbers. Time and Avg are showing all
Zeros.

This is my .config file:

CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_DYNAMIC_FTRACE=y

Am I missing something?

Thanks.
