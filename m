Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B4FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon,  3 Oct 2022 20:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJCUgO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 3 Oct 2022 16:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJCUgN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 3 Oct 2022 16:36:13 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED7D40542
        for <linux-trace-devel@vger.kernel.org>; Mon,  3 Oct 2022 13:36:10 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id r134so9038067iod.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 03 Oct 2022 13:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=ZQh9Vv24/hYzP6YnKuaZsyDlvZeSMA45x6u+8TxA7L8=;
        b=n5n4VYfEWRer8ziQopCYPiLwYxQWsWEOjuxcFDiy77OyjTL9jZwkyKP84NhhR3WCBh
         wqous7wYgIxwYjoRe/9gROwh7yBzYa0RBrWdQc3DUETNC0iYtyLEurfgS8eX7W/dfBXn
         TOXjEiouuwLDx5Rii4imOHNfYWB6RqPBT9baU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=ZQh9Vv24/hYzP6YnKuaZsyDlvZeSMA45x6u+8TxA7L8=;
        b=LCteTWym0l3jT2qtpm4xFoIJt5nq6+S66gb70nITZfO2kvmZqTAmFW3HoC157VhVG7
         b2yaDXZxEfRMvhYRPZ99tyKMeJnkfnLzV6jbYcPV/p0zCa6+QGAgxUlIGcPaMis8DOQ/
         8SZGFjlalSf+r8X1t1CheHDSIPhEqcQF7k2Pjq/3D4UAlykYIzlz+3mP/LvlDQuamxJH
         6h16lvfeWqYi6r2Tp72BimMST3SdQjS9AXDVEylc4HoTv1iuJ92EO1GqLB/Pfz06MJOg
         8YsqxYdLHnAyjLJI1WxdyDXHrYbfshftuhdo0G+qxFoNTOPx8jX/uP1PiRh1QuqvSyy0
         UyWQ==
X-Gm-Message-State: ACrzQf1MnKpp2NRNVpzn+s1M7j3ZiHso4X3hFZtiB8abKwRS9bQy2IpK
        iijOEL8/f1BwGm8hxv9/JYxlcpbAVAvKznFvk6jILoFsSPY=
X-Google-Smtp-Source: AMsMyM5Ut3ci5Vz9LAfcto2oavUf8QScQpxSbhk7xYp9SMGu2f9XfuGYIwMtr21PF40yxKd6MFLT/Tm8LQHTzUgtb94=
X-Received: by 2002:a05:6638:379e:b0:35a:6503:453c with SMTP id
 w30-20020a056638379e00b0035a6503453cmr11208260jal.118.1664829369860; Mon, 03
 Oct 2022 13:36:09 -0700 (PDT)
MIME-Version: 1.0
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Mon, 3 Oct 2022 16:35:59 -0400
Message-ID: <CAEXW_YRUty_YEkUXwSP_v0NHb6tC_tCFavYNze5kBiAuMmKz9w@mail.gmail.com>
Subject: Runtime verification for instances
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Daniel,
I was thinking about your RV for a recent problem.

Basically, we want to check for state transitions on a per-RCU
callback basis. For example, we want to verify that for certain types
of RCU callback, there is no chance of a scheduler wake up happening
(provided such wake up happens for non-hardIRQ context).

This means every RCU callback in flight needs its own automaton which
is created when the callback is queued and destroyed when the callback
is executed. There cannot be a single global automaton. And we have to
make transitions for different automaton depending on their state.

I bet you have already thought of something like this for tasks where
you need a per-task automaton instead of a global one for some use
case which requires tracking each task separately.

We can implement this in RCU itself, however it will be ugly due to
CONFIG options. And also we cannot do it easily in production. On the
other hand, with RV, we could simply have RV watch the tracepoints and
verify them. It will be clean.

This is just 1 usecase (wakeup) , we also want to extend something
like this to more things, like making sure callbacks execute in a time
bounded fashion. I know verifying temporal properties doesn't directly
fall under RV, but hey we can extend it somehow :) . i.e. we reach the
final state in bounded time.

Let me know your thoughts and thanks!

 - Joel
