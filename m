Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2070C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Feb 2022 18:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235223AbiBRSqN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Feb 2022 13:46:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbiBRSqM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Feb 2022 13:46:12 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84B746150
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Feb 2022 10:45:55 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id z2so8629874iow.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Feb 2022 10:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=6WM1FcbjkKRQfarjcZ6VAm2qHADX8fdzN6A1eulDXPE=;
        b=T8cieqQENscbjBwJdoX+6eB1+RilGObfyjfePv5WEdowXJJW3X9c0+3SSHGzLIxKQD
         3TrOwKmWNvpjShxef8IK0hN4I7tW9m+qSeIPG6BKitgfGFIgCDpLFiRpa0G2UiCucbaL
         dlM8HrsXW82RfpxFfkerA6h4UseeZ/CkPFVOU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6WM1FcbjkKRQfarjcZ6VAm2qHADX8fdzN6A1eulDXPE=;
        b=RdHcUqVI6ZTPZqssPNClooRyYJYVggOPPV6+MLjIRryaoNGVn+AqEX4FyRYInIuXKS
         zNfhgWKPDNWhpv91llGdJvEK9SVkGa2sP4ktSjr3ILzF2bN72GK8ZJsEScdjGx1Jb0yU
         WrnYoLU6ZyCijqURKirgdCC7/TdPPyD3I7PptYut7OO87sc9FFckY8xR1CximDDYn9A5
         +cAAdgY1gTR4G3jSVTvBKpTn4Ff4G5Xvh+D7ANJvuFfnBNM84YMa2DwAFoK26iDlZ6Nf
         mzZzYEcrou5UDQ47xg9k1V2jniVQbK2pEe8/tMFs34sVuUaaWmtOkIzV8feaumpzSGor
         jEkw==
X-Gm-Message-State: AOAM53336+V3Mx1ScPkHh32OHMuaPiYRU/5ZoLQs3d9WaSoobCZ//NTy
        1Fg7RlMrkOp/yCh+iEp2DS0RcZ+ohb7OHyHP98k9v+u3zQUGPQ==
X-Google-Smtp-Source: ABdhPJyQYmLOJIqg85CfKo+LucyFe2fr4+d9qQBPRcsdtx4Qr3CY6Hk9G90/VWzDBypA7diCOwDpQRUA3qOXsbB5WBI=
X-Received: by 2002:a05:6638:d91:b0:30e:345:a0d2 with SMTP id
 l17-20020a0566380d9100b0030e0345a0d2mr6047438jaj.257.1645209954974; Fri, 18
 Feb 2022 10:45:54 -0800 (PST)
MIME-Version: 1.0
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Fri, 18 Feb 2022 13:45:44 -0500
Message-ID: <CAEXW_YT5sCze=m-HubMjNLKmuUMqNQ_VbnT+7mmOULC-rJO8hA@mail.gmail.com>
Subject: Rotation of instance traces
To:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hello!

I am seeing something weird with trace instances, that I don't see
with regular non-instance traces.

If I enable some sched events and set the buffer size to something
tiny, like 1KB, I am expecting the buffer to rotate quickly as it
overflows, but I don't see that:

  watch "cat trace | head -n 1" and I see the following

https://paste.googleplex.com/6259651512369152?raw

and if I do some heavy workloads, I still see that the top rows are
not moving and are stuck showing the same thing. I am expecting the
buffer to drop old events as it is being overwritten/rotation.

 However if I do a tail on the trace, I do see updates. So tracing is
in progress...

I did the exact same experiment on non-instance global tracing and it
works fine. I confirmed that 'overwrite' is set in the trace_options
of the instance (and non-instance).

This could be some trace formatting issue or another bug? Note I am
reading the tracefs trace file directly and not using trace-cmd for
this.

Thoughts?

Thanks,
Joel
