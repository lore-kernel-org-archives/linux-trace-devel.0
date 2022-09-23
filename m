Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AFCCC07E9D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Sep 2022 21:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiIWVAN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiIWVAH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Sep 2022 17:00:07 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC0C63F11
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Sep 2022 14:00:04 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id q83so896579iod.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Sep 2022 14:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=+e0NanrLMT3PCLIVStvWbUFOinQx47LnGWSHXA48cP0=;
        b=n2ycpNJeD0KdLxVceWcTTB6SQa7u2cMVpPWfgXmDeNXFPe1dHhcqHMGiG99/A6mr1f
         UW4F3NTJ15zv0wM940cn/U3ziP9JYi5L6Xq4T4lV5DRPlgDe3K+kWM4I4tdFT2sSIt2W
         Itw3lA3yMS670pNiuL/9OeJnPRqCQk5V9yPUxEEfjwW1nMHhCdfFlp0DMcIS8oZ22uay
         qoW/I0FHw1ihPrRE5j8P6ArLc9z0eQlf+Sakz6FW30vddP3VsYZfwNCSVfek0kDH0XZA
         qz6InNTdTdpEtbciqWgoP81C4B+CrQ5oFFkJ1dwi7jlZtd5oxGLbf1udC8q8SZwcle02
         ZBrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=+e0NanrLMT3PCLIVStvWbUFOinQx47LnGWSHXA48cP0=;
        b=3AsA6Bz5THB7BjZUzqGWWN3rWqlzDV+QguleQTshn9mI0C8xCWa87snTzb5qyBjz+6
         1lyKJLmkikHqpyeQ/IhKuEj1XbuBw4pQA/iv7pA/yLYMDmcARYCa0j6lp6rkK80qmTb3
         xjiSNh1/NS9Mxaot7DjtdMRoY2pbhHWxdjkXEZZztKfR5HpWtvRv5D2GKbKp1h5itBVv
         rA3pxvzTBIZaWiNRq4yDppRHf4puJa6hY7rQ+8hsQqjt9s4w6oFRAnfyZQXEX6tNOIma
         NIHaLu9noP3/glJB5h5fASZWG2WunyiXGphF3CgQxxgF29qPGyOBMM2qbTS2uXcoJF80
         q+XA==
X-Gm-Message-State: ACrzQf3o0uhgsWk4btsGqT7Kxu0Ou87lsXB5IhGP83+6fJwMDFlBUg8u
        JKdQwRXYL4Gtke89Q5zcKxrUhWNTYe2NbQ==
X-Google-Smtp-Source: AMsMyM5uN6XGhPs8Mhvt2eTRNsdke7DerXl+b0QjZjFQ8RcE9QE3+DPX7ppSFZaRF9hHsfyH7CpxMQ==
X-Received: by 2002:a05:6638:d50:b0:35a:791a:3d27 with SMTP id d16-20020a0566380d5000b0035a791a3d27mr5513214jak.7.1663966803437;
        Fri, 23 Sep 2022 14:00:03 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:bad3:f10e:142d:daab])
        by smtp.gmail.com with ESMTPSA id n25-20020a02a199000000b0035aa9bf9d3dsm3815457jah.12.2022.09.23.14.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 14:00:03 -0700 (PDT)
Date:   Fri, 23 Sep 2022 14:59:59 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtraceevent: Fix uninitialized variable in
 eval_num_arg()
Message-ID: <Yy4eT5SdhjxEat4L@google.com>
References: <20220923123014.489e0e39@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923123014.489e0e39@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Sep 23, 2022 at 12:30:14PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> It appears that my compiler version did not notice that "field_size"
> passed to check_data_offset_size() in the TEP_PRINT_DYNAMIC_ARRAY case was
> not initialized. But other compilers do.
> 
> Since this case we just want to make sure the offset is not passed the end
> of the event data, we can simply pass in zero.
> 
> Fixes: efd32896dd5db ("libtraceevent: Add warnings if fields are outside the event")
> Reported-by: Ross Zwisler <zwisler@google.com>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
