Return-Path: <SRS0=o21U=56=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9637C2BA19
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 14:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C170B20768
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 14:16:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jRBng0Z4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733212AbgDNOQR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Apr 2020 10:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733211AbgDNOQP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Apr 2020 10:16:15 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5731C061A0C
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 07:16:15 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d24so4697907pll.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 07:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DBtc5MWeye/0BTib0aXXqURP9NZ1rDT6r5moFfW8VOA=;
        b=jRBng0Z4Uljd2lbVlO5KiSD88zNc7wnB5mm4yFG0HMQP2y3p7xsh8+Xg6A2M4zKFs1
         3HPYbT542tK3s5TXWrFZJMPvDihdVZUhmGI/lwd9znC01LrZ/yJsFsujKpvpKpVEwuAq
         1+vQZSvW/QC5SkmOjKCr5N+e+/AYGG4cFJZ9/V/CyN5JgfuOyP1lNaYxB2M54CafkyHa
         2+SmH7ggW0RDDtdFXwUSrgLo7xx0Z7/9EPvQbCuPzGvdoPRt6eZjihoG3M2tPndNMA/c
         Ron6Sy/2NEJuTuaspoVW5rrNrDlaYFe5APQ3xoINm+AJKKTk2FXLa9phSsHFfT1wVz4V
         fKmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DBtc5MWeye/0BTib0aXXqURP9NZ1rDT6r5moFfW8VOA=;
        b=rgIZPpjKNYnxUzpWAAJPyqT2B8tMoYdRcFZ3GZplNliIZwh5ZbTpQ5owYDAzReHn13
         Q9yTg5gKTY83YDf1j9sHsB1+tvzRRc1ZqiamdxJLhkk9aajbQccNG7qfaEfAmiULS8Ws
         Pr/lJBroUq3gqVMa0nIhahietF56rqw4vVb0tYAx29bB0WLX4TG2FcNHz0mo7DPZI+af
         PkoU/oLW0rWYcJ2QRFB4kZPyzBC+d8rE78Lnt4A2ZfvhlaxlQUZkyAv/hDAE4EtN3hRk
         YsYir9KNPFRnmi853HeeYSnG2/jBMjogZCNzn2nGHcEL7CNZkOJEt8qG/9V+E63xCMDW
         NmVQ==
X-Gm-Message-State: AGi0PuY8KLKcYS5dFLD5uBc1gf1gt5a6hSZX6fdhK5rrs6i2omIy7VZK
        UvJK/stvQt0ysDB5Jrq9ewz6626SBFk06SdUOCev3VBzneY=
X-Google-Smtp-Source: APiQypIaTWzYch73RsWxi6teV+M6EBhINzzDyUNGEDdZkAmLZl/WzmCjVvUfWlIWdFBgw98Rm7zwf0BWVOzF8OoFB88=
X-Received: by 2002:a17:90b:380d:: with SMTP id mq13mr305343pjb.145.1586873775293;
 Tue, 14 Apr 2020 07:16:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200414014403.968063641@goodmis.org>
In-Reply-To: <20200414014403.968063641@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 14 Apr 2020 17:16:04 +0300
Message-ID: <CAPpZLN5b2MsLpF0ajkHgQzg=dBDi_tkW7zhFgwkVRwyQcJds_w@mail.gmail.com>
Subject: Re: [PATCH 0/2] trace-cmd: Some more minor updates
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Apr 14, 2020 at 4:44 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> These are minor changes and instead of having Tzvetomir resend the patches
> with the updates, I just made the changes.
>
> First patch is to change the grammar of the function names that have
> "file_exist" and "dir_exist" to "file_exists" and "dir_exists" respectively,
> as they sound better for a native English speaker.
>
> The second is just a micro-optimization of the return code of
> check_file_exists().
>
> Steven Rostedt (VMware) (2):
>       trace-cmd: Use "exists" instead of "exist"
>       trace-cmd: Optimize check_file_exists()
>

Looks good, thanks Steven!

Reviewed-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> ----
>  include/tracefs/tracefs.h      |  4 ++--
>  lib/tracefs/tracefs-instance.c | 21 ++++++++-------------
>  tracecmd/trace-record.c        |  2 +-
>  utest/tracefs-utest.c          | 28 ++++++++++++++--------------
>  4 files changed, 25 insertions(+), 30 deletions(-)



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
