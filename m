Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9D3C04A6A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Aug 2023 17:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjHDRBG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjHDRBB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 13:01:01 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F654C3F
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 10:00:49 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-77ac14ff51bso83502739f.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 04 Aug 2023 10:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691168449; x=1691773249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v4TCdtGx4PLF0fJ1Mn7wht9Y0iFwsdMBg0lP6jlYJCA=;
        b=EXz/JVXEN70KAxzWqdS87KDsRIcBl4Fx/83XwzuAreirD9EwjV0JsFK0qAaBTYPsDn
         QRv82PfxGXbkKniZ1TejJIIUOyzCsUXkcl5OwTi/dkOc/OTNdQ0jV2chmGRVMXWtJqRv
         rTUS/z+Ebds0GOmmnTNS1zFevyd7I9f5h45cVgt66q/QnVWo+oY+1Rk9KQ4u8z+V5v13
         hwVUqnrEolp6dtbr8We+kR3WWuHHo88d3ozeZo1/Ce4MBF8jwZEDME6uXZt7x2omeMtK
         3tzv+LX2byZOczBU7wSdre6/Usilx32WV+5y6Dl6tQJm0Ej+z8zjnzHlZPrzgFlyh2ZU
         QKLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691168449; x=1691773249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v4TCdtGx4PLF0fJ1Mn7wht9Y0iFwsdMBg0lP6jlYJCA=;
        b=CnHWQ/P2eyN7Ubmz0kXktV0rM6NyL1iiL9OG0lqIhfAdX61UVBQTKaCNmBphGBmoUM
         UmY4NNZSPowv9VRKJXadQCmuxAP3XEGY21s9s1dQjpuFipznO4bgurPnvtjP8uqe98E3
         buN3G9xZv5LTYBIPXQgytFQKiJcA4c07PCvDm6v65meWWAcr3L2xFDiGEHjw9XlUsP7T
         muSa2zoxiZF3M2VmpvJ+h+YgsmxaO22gFiFYaDha4KiWtE2gWmt4IPYqkbNKiVlcMqcy
         mpNhS2MTRt3ebscG+cVmRXVB8UxNqyCkn/NHB3y4Phuh32S9VW4Ng5e0pTqku6YFWKd/
         76OA==
X-Gm-Message-State: AOJu0YzLRhLaKWcN0f4Z79PkSP9112qXMDZgymCmhw17nuqBvqObkJXl
        egMJuY8mxw1chHSRUwgZZ64hJPXpmhsv/XiyZBcZKA==
X-Google-Smtp-Source: AGHT+IFGg3MVG0rNyy3zFp2WdiUB8MHqjeA9yRqVFEKAh2IsIAf12JmCrE8gb/5EXwuq4s5Xt93LGQ==
X-Received: by 2002:a05:6e02:1a28:b0:347:712c:dc9 with SMTP id g8-20020a056e021a2800b00347712c0dc9mr3127469ile.22.1691168448599;
        Fri, 04 Aug 2023 10:00:48 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:1c86:9b99:8ac1:8749])
        by smtp.gmail.com with ESMTPSA id p6-20020a92c106000000b00348a5e95d47sm760806ile.14.2023.08.04.10.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 10:00:42 -0700 (PDT)
Date:   Fri, 4 Aug 2023 11:00:34 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH] traceeval: Remove free_results()
Message-ID: <20230804170034.GA4046351@google.com>
References: <20230804095219.41d66349@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230804095219.41d66349@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Aug 04, 2023 at 09:52:19AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The static function free_results() was never used. I kept it around for
> when I was going to add it (and to remind myself not to forgot about it,
> which is why I left the warning). But now that the code is being
> rewritten, there's no more need to keep he warning around to remind me to
> attach it. Get rid of it, all that code is going away anyway.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
