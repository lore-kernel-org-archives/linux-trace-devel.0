Return-Path: <SRS0=D6y3=CL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D78DC433E7
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Sep 2020 12:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52E852078E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Sep 2020 12:36:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DhdUQNgH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIBMgf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Sep 2020 08:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBMge (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Sep 2020 08:36:34 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D697EC061244
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Sep 2020 05:36:33 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mw10so2282314pjb.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Sep 2020 05:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=BQcAbCcWQClbjNNLTcQgFOblapbY/KsryBkhOMqTXwM=;
        b=DhdUQNgHq2JqhVvHhhAiZvwhy0vD3nCxqv4KTvzk2kRYdYt+prCMc/oLrrJmTX5ISc
         D+Pcr95VlJ4CybI1mTUjh1qebhrWhc33ijyuRSDlIrPKy2bPO5jNRrkAj/LklF5HgVFY
         +tC9xEunbrFzhBLibUHKS04Mw2DktAlYpVozEJu9scAJvMu2l9Qcs8DwP0QgJ6ZN2h0l
         MW2owh2aLU6xzrGCI6Fz2Y7nIbszKl1TMrEcPRvaiQja+2ebp60lrIBpIc+rSuFnjzIt
         NUDDB7jh2yClJKoFj+tbmhlq7RRkKF1SPJEVERF2tnYw7M/XjWiJukAFDr2c2TT4Wmox
         CD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=BQcAbCcWQClbjNNLTcQgFOblapbY/KsryBkhOMqTXwM=;
        b=KvJL80cbBzW4T1qjEGr1F1X8o3hpzxxioHBLKgrgf0zu0YVGdbXxhNmEtyhn2Tx9L3
         MeTjhSMoYeDht54KF/K1STnID1Ve5pepXOxUK4ZjULUuheOepC3OuCZS/zZFfWD+pU4Y
         B/rWTVY+460sckvGCZCy8MgStypoYGZ5gB6pSn36upLPFKmJS7QKJ7+sn9ukg0C5BN1K
         p2Wgk66ObO20bgvEax48f3BTbykE17C3sWpVLGifK7JkPSHUL/VYtRVzKlhOJPqJHvKK
         Hq3r/ddbd80FJSbdApY+YAF2XFJHuITDVTlZXlXf2gTvnikhFB+El52uE1gU3QNR9/ux
         q1ew==
X-Gm-Message-State: AOAM530578hsd0qynBncjzc+uW+3CsJpRk+dqt1dzO48Gzn4XI2sz7BF
        LgjQ24JWHBLi5NU4KSPTvUQHTUyddBDOEM4q2Xk=
X-Google-Smtp-Source: ABdhPJw1CmYLA9MEyxQAKPKvB8zx3oQwWLUdB92LEiwdyv8AUxWAN/YACW8Ehx+BpSKhPlnV1qc6e7LOQP9nyDsQoSo=
X-Received: by 2002:a17:902:aa89:: with SMTP id d9mr1945456plr.192.1599050193373;
 Wed, 02 Sep 2020 05:36:33 -0700 (PDT)
MIME-Version: 1.0
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 2 Sep 2020 15:36:21 +0300
Message-ID: <CAPpZLN4JPgANOyWs5LNC4hyz+pvKBS7a-n5j8UiiALD_3Qp=tw@mail.gmail.com>
Subject: Guest TSC clock offset
To:     Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi all,
I did a quick research as follow up our plumbers tracing BoF, here is
what I found:

KVM maintains per VCPU TSC time offset and scaling ratio:
    vcpu->arch.tsc_offset
    vcpu->arch.l1_tsc_offset
    vcpu->arch.tsc_scaling_ratio

There is KVM ioctl for getting the current tsc frequency of the guest,
works per VCPU:
    KVM_GET_TSC_KHZ

There is a newly proposed patch set introducing new KVM ioctls for
getting the TSC offset, per VCPU:
    https://www.spinics.net/lists/kvm/msg220471.html

KVM ioctls are well documented:
    https://www.kernel.org/doc/Documentation/virtual/kvm/api.txt
 Each KVM ioctl has a scope: system, VM or VCPU. The VM and VCPU  ioctls can be
 executed only from the context of the task which created that VM /
VCPU. As ioctls for tsc
 offset and scaling are with VCPU scope, we cannot use them from
trace-cmd context.

There is a kvm_write_tsc_offset trace event, which can be used to
track the tsc offset.
I observed that the offset is quite stable, at least in a short period
- there are few small
adjustments. These offsets are set at the VM boot time, so we cannot
rely on the trace event
later. We can track it, just in case the offsets change during the trace.
 CPU-9094  [001]   800.866350: kvm_write_tsc_offset: vcpu=0 prev=0
next=18446742520796313836
 CPU-9095  [001]   800.867593: kvm_write_tsc_offset: vcpu=1 prev=0
next=18446742520796313836
 CPU-9094  [001]   800.903735: kvm_write_tsc_offset: vcpu=0
prev=18446742520796313836 next=18446742520796313836
 CPU-9095  [001]   800.903858: kvm_write_tsc_offset: vcpu=1
prev=18446742520796313836 next=18446742520796313836
 CPU-9094  [005]   800.916755: kvm_write_tsc_offset: vcpu=0
prev=18446742520796313836 next=18446742520796313836
 CPU-9095  [001]   800.916800: kvm_write_tsc_offset: vcpu=1
prev=18446742520796313836 next=18446742520796313836
 CPU-9164  [000]   802.612779: kvm_write_tsc_offset: vcpu=0 prev=0
next=18446742517485073862
 CPU-9164  [000]   802.629874: kvm_write_tsc_offset: vcpu=0
prev=18446742517485073862 next=18446742517485073862
 CPU-9164  [000]   802.632420: kvm_write_tsc_offset: vcpu=0
prev=18446742517485073862 next=18446742517485073862
 CPU-9246  [007]   813.272152: kvm_write_tsc_offset: vcpu=0 prev=0
next=18446742497274838435
 CPU-9246  [004]   813.289768: kvm_write_tsc_offset: vcpu=0
prev=18446742497274838435 next=18446742497274838435
 CPU-9246  [004]   813.292385: kvm_write_tsc_offset: vcpu=0
prev=18446742497274838435 next=18446742497274838435

There are entries in KVM debugfs for getting the offset and scaling,
per VM and per VCPU:
 /sys/kernel/debug/kvm/175263-14/vcpu0/tsc-offset
 /sys/kernel/debug/kvm/175263-14/vcpu0/tsc-scaling-ratio
Where 175263 is the PID of the quemu task running the VM, not sure what 14 is.
I noticed a small mismatch - the vcpu->arch.tsc_offset is u64 while the value in
vcpu0/tsc-offset is printed as %lld and appears negative: -1552913237780.
Seems that the best solution is to get the offset and the scaling from
here + may be
track the kvm_write_tsc_offset during the trace, just in case.

I have few concerns:
  The solution is KVM specific. Maybe we should keep the PTP-like algorithm as
  a fail-back option for all other cases ?
  This offset is applicable for x86-tsc trace clock source only. Should we force
  the user to use only this clock source for host-guest tracing, or to
allow using
  all trace clocks ? In case of a non x86-tsc trace clock, use the PTP
to calc the offset ?

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
