Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B73C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Apr 2021 14:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9600E613AB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Apr 2021 14:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhDMO3j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 13 Apr 2021 10:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbhDMO3g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 13 Apr 2021 10:29:36 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB41C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 13 Apr 2021 07:29:15 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id n138so27751647lfa.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 13 Apr 2021 07:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edu.unito.it; s=edugoogle;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=+bH+jJMHvBtlSNFwyFrwdlffGh9P8q79opdB9jmfbZI=;
        b=cnUOk6juTbg28SsNd7RWukYGTwudOJLufvh6nEbxYExbCZmWvgVXWDZB3skk6g5vAu
         xqukbH4s/evxiOI7hdxC1+7dIkK4wj80oPMM+fUQN+gottjkDtJ1mlNO7OGwcmQtLB+y
         Bw2wbP6W8Ye1zp9NPXfuZNR+LegKOsFBf8EXM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=+bH+jJMHvBtlSNFwyFrwdlffGh9P8q79opdB9jmfbZI=;
        b=n+0Lf1IIsbRZx2DRKwJWvYjMUGxfrKSGu8oTLlxf0gRjZoYzR71pvmrZJq0VK4cMTF
         KfQktpk8Qr46p0zfkBQXGNbK16Uegv8FrZtRNm0ngiGO3Ln8ZaTzfPgjhTR3g51FJ7nU
         FTfah0bW815VspT+dCXx0jOIiWQsG3fFA/WhITVIguP2ek6BAgNZFop1A8na0hdnSy+g
         rX16LJ5ZEd6u9TMNZC81P/dPlJkTxZxusWjZS4np0RZaAyVSa8ejHR8W9AzimIkLRA82
         75BLqw8+0/a3LuD8+5IL9PeykHJieJSyjRjGFaKfQJq+M6yFgH/5Gas1Z50foLAV3IWM
         CVsQ==
X-Gm-Message-State: AOAM530Q1f+SqbWoRyPA8qIm0IH7QbZel1A/7tu6Uf09arCGJkDYiSij
        wVjL6lxjZFl7EIr/neJrQWNX886r2y/MlzvFmv0XolBQDKCYPnGoERXKJxjpm/G+apr3SPT1sXO
        slaCQOiVqWmy1IvA8iI0Vb/oBzWY7Qbrk3xI4T+3JAkAI07kDit0=
X-Google-Smtp-Source: ABdhPJxF1NNfPcCtW+UbtaU9uKYYR1jdlCW68sMOR5FUQw+Z7jEjT1CkWUshPASg+njaA2sR8x81MV6WQqyiXlkXn9Q=
X-Received: by 2002:a05:6512:11e9:: with SMTP id p9mr6488422lfs.20.1618324152441;
 Tue, 13 Apr 2021 07:29:12 -0700 (PDT)
MIME-Version: 1.0
From:   Giuseppe Eletto <giuseppe.eletto@edu.unito.it>
Date:   Tue, 13 Apr 2021 16:28:36 +0200
Message-ID: <CALTQNB5X1+G33Qoh5nNxttQe_GkzKvJFLfEXQszsc6XYr+NgUA@mail.gmail.com>
Subject: =?UTF-8?Q?A_KernelShark_plugin_for_Xen_traces_analysis_=E2=80=8B?=
To:     linux-trace-devel@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     Dario Faggioli <dfaggioli@suse.com>,
        Enrico Bini <enrico.bini@unito.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hello,
I want to share with you a new plugin developed by me, under the
supervision of Dario Faggioli, which allows the new version of KernelShark
(the v2-beta) to open and view the Xen traces created using the "xentrace" =
tool.

In fact, KernelShark is a well known tool for graphical visualization
Linux kernel traces, obtained via "ftrace" and "trace-cmd". Anyway thanks
to its modular architecture, it is now possible to implement plugins which
open and display traces with arbitrary format, for example, as in in
this case, traces of the Xen hypervisor.

For more information on how to build the plugin and/or
to view the source code I leave the repository below:
https://github.com/giuseppe998e/kernelshark-xentrace-plugin


In short:

$ sudo apt install git build-essential libjson-c-dev
$ git clone --recurse-submodules
https://github.com/giuseppe998e/kernelshark-xentrace-plugin.git
$ cd kernelshark-xentrace-plugin/
$ make

$ export XEN_CPUHZ=3D3G # Sets the CPU frequency ((G)hz/(M)hz/(K)hz/hz)
$ kernelshark -p out/ks-xentrace.so trace.xen


You will need the development version of KernelShark, available here:
https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git

A screenshot of the plugin in action is available here:
https://github.com/giuseppe998e/kernelshark-xentrace-plugin/raw/master/.git=
hub/img/ks-xentrace.png

I'm happy to receive whatever feedback you may have about it,
and to answer any question.

Kind regards,
Giuseppe Eletto.

--=20
------------------------



Indirizzo istituzionale di posta elettronica=20
degli studenti e dei laureati dell'Universit=C3=A0 degli Studi di TorinoOff=
icial=C2=A0
University of Turin=C2=A0email address=C2=A0for students and graduates=C2=
=A0
