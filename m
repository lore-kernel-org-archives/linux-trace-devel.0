Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E852C001B2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Dec 2022 17:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiLVRgT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Dec 2022 12:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiLVRgQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Dec 2022 12:36:16 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9791D65B
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Dec 2022 09:36:15 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id s16so1305616iln.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Dec 2022 09:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xxbtJkaA4NrgfeNsYYGJshta1PFZsmKgRV+XuLY07Yo=;
        b=caJ9q37TkMBpRRGAZmpEoGI2rSu/RI36uUNTzFqNNwpz4L9CbGTaZm5Mq2oajKE76I
         EX+bjaGipS0fhvMbX/TWLHtfCfa8wP+y1bweQsaGP4udw1/6H1K1coqLE++EYsZdjhvA
         naBuCuvPGtBhhh4HohC5BWnWEz5rrhiO3Vk3Y8DxN/HR+akosGEiZuUQFzi13s8kQvLo
         pRmx93cA7qITc17kvzREOArBsDo+KCj5A7wdILZAlTiky111IUZZ9DZDf92E7InYhTSM
         7Ygz2PyGDzxfwuvJLFD6eE6vsHq7DSzH/xLGp7pVF7KV6O1gVj1Kzmv3JXE2CxuJIzlr
         Tz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xxbtJkaA4NrgfeNsYYGJshta1PFZsmKgRV+XuLY07Yo=;
        b=T4HRI5URjdyaq+4jphp+NOXS2OjhU4UoB4Lq9x2NVe7CrI66BbFtkTgn9zuN3CCUBw
         qb1Evd1yoK/9YmeGPZhlmDn9kKH59Cuft+zOjNRTJzyAoGimgdBDSVT/Cn7w9K590Orj
         Hgo0oVsCWziJfFka97jloYrfHfOzHtOv+u69xd3XXbK8YMR4yK5peMEX9KmyOcqp5Unl
         8yfdvz/1TjwaZAsLb74QFBEWKetWCeLW0FEACxkYg50fQR+S5u7RC4TL9P9KuXtmPsHz
         S+MhcrOBhzMut7Wl+Rz2BPkX0WgzWCxM3OOseXzsD0WbYqEy1O2HmpYhwDmnc2efhbKp
         wdCQ==
X-Gm-Message-State: AFqh2koMv3BCXVm80LFfcD44gA7hy5lxkKnWd2HWtHH8edQJyfZKA2e6
        cZGgejLpoEsdVhCAIDhfpukeZForaUC+CbHF
X-Google-Smtp-Source: AMrXdXtR1SIKd1pR2dO1dn4ZnlstXNWZXdibBi/zBQphFJ/HHz6lkbStIEI8UX/Y6UiujsC4g3/BpQ==
X-Received: by 2002:a92:c948:0:b0:303:62c1:7345 with SMTP id i8-20020a92c948000000b0030362c17345mr4468597ilq.9.1671730574653;
        Thu, 22 Dec 2022 09:36:14 -0800 (PST)
Received: from google.com ([2620:15c:183:200:ff89:86b8:e1a6:df49])
        by smtp.gmail.com with ESMTPSA id u4-20020a02cb84000000b003762308fe54sm255949jap.93.2022.12.22.09.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 09:36:14 -0800 (PST)
Date:   Thu, 22 Dec 2022 10:36:10 -0700
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Mike Frysinger <vapier@google.com>
Subject: Re: [PATCH] trace-cmd: Make sure 32 bit works on 64 bit file systems
Message-ID: <Y6SVioLoceN2EG6R@google.com>
References: <20221221135154.427ad9f4@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221135154.427ad9f4@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Dec 21, 2022 at 01:51:54PM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> As stat() can overflow if a 32 bit user space reads a file on a file
> system that has inodes greater than MAX_INT. Compile with
> _FILE_OFFSET_BITS=64 that mitigates this problem on 32 bit user space.
> 
> Reported-by: Mike Frysinger <vapier@google.com>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Tested-by: Ross Zwisler <zwisler@google.com>
