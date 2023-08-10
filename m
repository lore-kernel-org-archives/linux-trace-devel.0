Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C3DC001B0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Aug 2023 21:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjHJVQR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 17:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjHJVQR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 17:16:17 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54812737
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 14:16:16 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-79194701ce9so19744839f.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 14:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691702176; x=1692306976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mIfwsf8WmHOFkDip19W7VrNa2GAEX1v11NDRhPQRiE0=;
        b=ykouLUI2p0ZjqSJu788pUJSpKcIrWADQshdsCUzPMe5MzxoR1Hcxb1b0hVSpi5wrvP
         pNWUM1LMsSaARlOhIO2SSjhg+ERizxkFfKp+uONs4Gyr8KtMVSYGjspjj6olb24XubPb
         +NrUh4VeKX5Q1akcyPNMJZeXej2DIxHT9Nb+KUVj/ejMtFvzO2Whw4X2M5TEXso72l5R
         mkEby4q9VYPC/RkMMo0K4N4kZivEGupxfcvErMmQmxdMnlRTD1IBPdfNwFjNCcxz0Rbq
         47G0KELJe+8H7a31rXiXQtIZiImxLktbiUvAN1/fZOnZLtkc6yPfiX+WytLxWnybcDnI
         e0Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691702176; x=1692306976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mIfwsf8WmHOFkDip19W7VrNa2GAEX1v11NDRhPQRiE0=;
        b=TJa62jVWEtVIYVtU4jgFvmLyJY1A0r0UVZ9V7lvp+3dsKyIMFyYOGWNCMBzpSs9api
         bZnhIJxlqtouNdgtbetJ2Wv1h4TtMRIjMtTdFS7B3rfzIpjwhNfQ/mrFkcYPFyKY/a9U
         +uD6Zhv/yvxIkCEMOrc7sG06to1hS0a/oEo6RNhCuT7NmKe6CyBAPedryp1q44lnrQD6
         HKip0Qz4rHY9hXYnrM8+LWem+ZLWtBvJNb4aDIOcANSzxiy5QgvxfiV4vlMRj0T+vk+x
         fA7XWwGecpgEye0T+vspLvlCG+uMm8tRBTp5Q+cN4VgYdkFJmi28t/MXS4FRX/rIkDU+
         mKuQ==
X-Gm-Message-State: AOJu0Yw+OJTCkHx4+NYDsYGA+a45QyIGapBS5L6kNny3AAHwoM1rRU15
        GPhJD8YQlr09SGlAXcIq2WrQrA==
X-Google-Smtp-Source: AGHT+IHj2C9cFB5eFjvIicPzneJztUKvaMsgItw+M7j7SILWypAH0IQlUV5eqhX8Yq7X872JW7QJcQ==
X-Received: by 2002:a05:6602:2043:b0:790:c461:6f34 with SMTP id z3-20020a056602204300b00790c4616f34mr256147iod.3.1691702176020;
        Thu, 10 Aug 2023 14:16:16 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:b3b8:373d:6e9f:f058])
        by smtp.gmail.com with ESMTPSA id s23-20020a02ad17000000b0042b15e54a2dsm609529jan.170.2023.08.10.14.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 14:16:15 -0700 (PDT)
Date:   Thu, 10 Aug 2023 15:16:11 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] histograms: Fix memory leak, logic bugs,
 legibility
Message-ID: <20230810211611.GC1961992@google.com>
References: <20230809175340.3066-1-stevie.6strings@gmail.com>
 <20230809143041.39ad7ae8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809143041.39ad7ae8@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Aug 09, 2023 at 02:30:41PM -0400, Steven Rostedt wrote:
> On Wed,  9 Aug 2023 13:53:33 -0400
> Stevie Alvarez <stevie.6strings@gmail.com> wrote:
> 
> > From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> > 
> > Changes in v4:
> >  * Reorder enum traceeval_data_type numeric types for algorithmic access.
> >  * Reorder union traceeval_data numeric fields for legibility.
> >  * Remove parenthesis from function name in kerneldocs.
> >  * Optimize logic in type_alloc().
> >  * Distinguish internal vs public interfaces within include statements.
> >  * Rework copy_traceeval_data() logic for legibility.
> >  * Rework comparator return types to fix query and insert bugs.
> >  * update_entry() frees the entries old values to avoid a memory leak.
> > 
> > Steven, I didn't get around to adding in the cstring field to
> > traceeval_data, as I wasn't able to completely grasp what you were
> > looking for. My apologies.
> 
> Thanks Stevie!
> 
> I'm going to pull these in as-is and build on top of them for the rest so
> that you can work on other things. I'll still do a review of these patches
> for your own understanding, but you don't need to send another series.

Thanks for these, Stevie.  You've addressed all of my review comments, so
Steven, feel free to add:

Reviewed-by: Ross Zwisler <zwisler@google.com>

when you apply the series.
