Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1925EC38A2D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Oct 2022 07:11:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiJYHLC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Oct 2022 03:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbiJYHK6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Oct 2022 03:10:58 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A03F614D
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 00:10:55 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id bp11so18762296wrb.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 00:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SAJnW+569TQ1FBUmUUCeAdNtUDFGo8P1QiIN/iflRYk=;
        b=SmXLR//o8UKef0+EmWgy09DABqXcnr5XLYulZ6fK0cs7ra0L315JTfoNk1YmmmROtX
         fLaz1PzQ+5pLsB5XjK5cCJhdNKKStPt96o6SN5RqllWUW78dYMYhLkAldf2jfn5IRwfD
         q0Clmtn+zapNSGnHi8VGrmTooLbdXot7GQMBL2xgXEGaVvjTqg/51dz3l41RPdjhQoOC
         o7KJkRmsQa7LwuJyFBh7b5viRM+GD/8LOzw8d8NsKIWqZGqCOVZnnNXoQRgXGTcUhKF6
         X3nfXTKMXvpr9i+0OsjyvRaEMo7Nll78/D7QqvGcYAl5sOOyEXh7GCOtwE5Efo6HcN+Y
         TBVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SAJnW+569TQ1FBUmUUCeAdNtUDFGo8P1QiIN/iflRYk=;
        b=UymjEnHgqDGiVHZYrXLs724AUHIqLvWHalkaV28Onf1KShqLGXpwgALVIJIWJwPTt7
         NK8y61hieiC014uafH1EXUed7lV2NIbkRlcFRJ6hNM9PDsPveTah567nU66cS5FLPr/E
         0OKWQAVvwVAx8/mNj4B7niKwnqWTGLZXZplTAz890RQLpJPHV3c8exWgxeeCZEtH//Yd
         FKNfBv5FgveRi6xrMQMynT+JHRFRtFP3jknLh06GhxVBDl8htowwQwBqP3M0pFQSEzVK
         wTJBc1+G57vKZab35OCfWlm5zhoXMW1m0uCeSW6gtRpj/1yP0oXnYIYu/dahZ0d/RVJy
         OhuQ==
X-Gm-Message-State: ACrzQf2NFakEIfr2sHN6vah0nX6nHz4asqqPyW9zDcPD4bDNGyCYlPlQ
        dvu3XznTvY3Gm6G9d6r49UTsNRcFp78jSpVuv+E71ur2Cpc=
X-Google-Smtp-Source: AMsMyM7M6lS3/kOSLyjKpQpRTnyp3rki3vCRSuaozBQRVk+cLLP5iq0j6ppwebtFxM/DqGXF52Wn8nXEB6DvD0RsUdk=
X-Received: by 2002:a05:6000:1ac7:b0:232:8c6c:6c4a with SMTP id
 i7-20020a0560001ac700b002328c6c6c4amr24242857wry.455.1666681854004; Tue, 25
 Oct 2022 00:10:54 -0700 (PDT)
MIME-Version: 1.0
From:   richard clark <richard.xnu.clark@gmail.com>
Date:   Tue, 25 Oct 2022 15:10:42 +0800
Message-ID: <CAJNi4rN7WkbEJkr9+vP1bOXQ_U=4eyDSaHb1aqJti_rTs2K7Hw@mail.gmail.com>
Subject: About the output interpretation of the wip RV
To:     bristot@kernel.org
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Daniel,
I got several dmsg outputs like this after I insmod the 'wip' into
system(with printk+dump_stack reactor, trivial changes for the wip):

[78706.972957] event sched_waking not expected in the state preemptive
[78706.972963] CPU: 2 PID: 410 Comm: kworker/2:4 Tainted: G
OE     5.15.70-rt50 #1
[78706.972972] Workqueue: events igb_watchdog_task [igb]
[78706.973000] Call Trace:
[78706.973003]  <IRQ>
[78706.973006]  dump_stack_lvl+0x61/0x86
[78706.973016]  dump_stack+0x10/0x18
[78706.973022]  handle_sched_wakeup+0x92/0xd0 [rv_poc]
[78706.973028]  ttwu_do_wakeup+0xc3/0x1d0
[78706.973038]  ttwu_do_activate+0x6e/0x100
[78706.973044]  try_to_wake_up+0x209/0x700
[78706.973049]  ? hrtimer_interrupt+0x11f/0x230
[78706.973059]  wake_up_process+0x15/0x30
[78706.973065]  irq_exit_rcu+0x9b/0xe0
[78706.973074]  sysvec_apic_timer_interrupt+0x92/0xd0
[78706.973082]  </IRQ>
[78706.973083]  <TASK>
[78706.973084]  asm_sysvec_apic_timer_interrupt+0x1b/0x20

Does that mean something is not unexpected in the system?

Thanks,
Richard
