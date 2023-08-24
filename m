Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64B0C27C40
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Aug 2023 20:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243410AbjHXUHn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 16:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243414AbjHXUHY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 16:07:24 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF19BE4E
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 13:07:22 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-7909307ecd1so7170739f.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 13:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692907642; x=1693512442;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XgHOP+N4JqqE2NvPsAypUNaszLx5WwrPbrZPkn+NRzo=;
        b=PLolhH6Oz+Cyctaf1uBieKHkUSA3NEe0RDfz9y1d0tTGn2FNeKYY0blm67JuUQjf0r
         GGe9nzPWZnu+Oa6wkh/F561u4co8WU3Vm7DOUsVPeT1Ola6ZuC9umTWRkElFUZKPqUbQ
         M9JORW7WXm7DX+nJ/acW1my4xfqbaCMrY+8Wd2I2yAHcKyJ9b5mXC7r8DpRNK8B6Sxw4
         xaMKICIM1QLv3aePOIxJXnwFRugVclyt5zZ2kysVR/+ObhuzwcE7wB7n43J1khO4jpmn
         Q7hsyiPi6vkijoiw+zFuE6vQX12kNl43K+PzQcbJHv9NxOjdHRpB/R5GhzVwxLMp9qXS
         pioQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692907642; x=1693512442;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XgHOP+N4JqqE2NvPsAypUNaszLx5WwrPbrZPkn+NRzo=;
        b=JuK98HMfX1AvJoGx3IetvB2p6BNEZfenoMsyYiW9m81cg3tVXDBE/rivKD3CgT3eyR
         fWVRtEHcYQ204OjotouaiAhgut7EcVdhdHrQReyYDL20TARxxUjedsfhB+IhfNYs1REk
         khZcn8okXFJO73AGVckDp6Vrmmnaie0OuM8aUdK/OeMzIpinHJYqEnhiw8Q204sXI35b
         TtuSq+hWIh/1eX3dtc8G0IYnubfCiEE6mLUu1rCtSxnSugW5TUwxwMwdlleeTmHvjHUd
         IfnwhjwuVQfMBQvKwuX8nfnvtpkACxNl85D6rqVtHVz7rxVQ10QTleVeOfwLu8jJo5C1
         IPmA==
X-Gm-Message-State: AOJu0YxfrkbSUI3j8Pzwv3uK6qUAkQyYIGo0W7xURhu1ef11S4GJ6weT
        gchmvvmRp8/aNGjXBO4f17zBJw==
X-Google-Smtp-Source: AGHT+IGX0w/GIW3JQkUHGg9yYA3QJfEEGXF4feeRKfXTkYHHBRNHWlJ8JAdpx12WzoR5+2/2F6bITQ==
X-Received: by 2002:a6b:620d:0:b0:787:34d:f223 with SMTP id f13-20020a6b620d000000b00787034df223mr7031920iog.11.1692907642163;
        Thu, 24 Aug 2023 13:07:22 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:12f4:1fa1:277e:6e17])
        by smtp.gmail.com with ESMTPSA id r4-20020a02c844000000b0042b3dcb1106sm68244jao.47.2023.08.24.13.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 13:07:21 -0700 (PDT)
Date:   Thu, 24 Aug 2023 14:07:18 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 3/9] libtraceeval: Add traceeval_iterator_stat()
Message-ID: <20230824200718.GC110858@google.com>
References: <20230817222422.118568-1-rostedt@goodmis.org>
 <20230817222422.118568-4-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817222422.118568-4-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Aug 17, 2023 at 06:24:16PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Add traceeval_iterator_stat() that will return a stat of a value of the
> current entry from a traceeval_iterator_next() loop.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ross Zwisler <zwisler@google.com>
