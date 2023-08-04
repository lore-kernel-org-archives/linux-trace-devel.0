Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 286F6C001DB
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Aug 2023 18:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjHDS2J (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 14:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjHDS0Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 14:26:25 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310315592
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 11:25:49 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-68336d06620so2192021b3a.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 04 Aug 2023 11:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691173549; x=1691778349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Uj+qHSCjfbUWLRY+Fwt1VqSSv01Dlprqpkb03sOELY=;
        b=K4iaYJe62LJTrS5Ph0sVcsrD2dIrPtEESzWnn9bbx5sz3e3VW4fIpQZqHgzqNml4jh
         F3z53qSZH/Zcb36ktoV8StnL1H6gDFH6d6KzPH/P6+usBK6ZiJ+2FaW3b23Eedvnuzua
         zXr1bUWpIpATDxiza5JCbBQZhHKO55xR4aSNFkZL5wuzUmEcV2tSOCk0OmySJGR/jHsa
         LwWFVYi12nD2JmSm7HvSmESmIAxsXzBj9edXfaHlhZocI8GyRqSW8Jqpz4eViuFNEdtO
         /6hZzRJzQCxe6ajIgk17VxvCN1V+Uh5uQtGOktGxyde8Ge18rMaVh9gdzFL7COCOdJoe
         DDSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691173549; x=1691778349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Uj+qHSCjfbUWLRY+Fwt1VqSSv01Dlprqpkb03sOELY=;
        b=mAMCa9vNnYWNFtl6ctONdFVls4JwoB0ODu2Q4pgYC0QvE5pvbA03smHimjRBblPFhQ
         HCSrcvepUdC4W5v/MUkqgsrzneeX6ISxl1uVzfMlZVfiQxgtKYXQoiQ2y2CvW7K4i6yn
         edBEVdlB+nNAHNzXA+SSlDcvr/mB9LZY4km1zYbAlSKksfzS6Jke4OcBSbO0SOAIPsMp
         r+AVMIJvBGIvdBTXUwrLEYuics/5ASaJcbjcLBE0+E73R5tMiYAQHoqpmjjgyrQ7s93t
         05xs3krhED9vZfXbwxYHcRaX83T9ykcNIb1say1wdjlIiiNcn26u/2TedVohLX84Cqqq
         Sw1g==
X-Gm-Message-State: AOJu0Yw6dLs9nwZXig2QfFb75K4LyE9Tt02uqDVIQgq91x3LMJBoaePU
        y+e85f39u5lKsHtJYrL0yro=
X-Google-Smtp-Source: AGHT+IFOs2gnpcV7nLuHXZ41fFL/o12pBOjB81iMULvedbjhGJRxwKCOkJWUv2y962eVAiVUdH4nVA==
X-Received: by 2002:a05:6a21:99a1:b0:13d:40a9:8ac9 with SMTP id ve33-20020a056a2199a100b0013d40a98ac9mr3331804pzb.40.1691173548994;
        Fri, 04 Aug 2023 11:25:48 -0700 (PDT)
Received: from 3xKetch ([2601:600:a17f:b422::ffc])
        by smtp.gmail.com with ESMTPSA id g12-20020a63be4c000000b005641bbe783bsm1237629pgo.11.2023.08.04.11.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 11:25:48 -0700 (PDT)
Date:   Fri, 4 Aug 2023 14:25:41 -0400
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v2 1/5] histograms: Initial histograms interface
Message-ID: <20230804182541.GB4353@3xKetch>
References: <20230803225413.40697-1-stevie.6strings@gmail.com>
 <20230803225413.40697-2-stevie.6strings@gmail.com>
 <20230804095058.756fccb0@gandalf.local.home>
 <20230804174159.GA2510@3xKetch>
 <20230804135718.70dba76c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230804135718.70dba76c@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Aug 04, 2023 at 01:57:18PM -0400, Steven Rostedt wrote:
> On Fri, 4 Aug 2023 13:41:59 -0400
> Stevie Alvarez <stevie.6strings@gmail.com> wrote:
> 
> > > > +struct traceeval_type {
> > > > +	char				*name;
> > > > +	traceeval_dyn_release_fn	dyn_release;
> > > > +	traceeval_dyn_cmp_fn		dyn_cmp;
> > > > +	enum traceeval_data_type	type;
> > > > +	size_t				flags;
> > > > +	size_t				id;  
> > > 
> > > Let's reorder this a little. Normally function pointers come at the end of
> > > a structure. That's more of a guideline than a rule, but let's have it here.
> > > 
> > > struct traceeval_type {
> > > 	char				*name;
> > > 	enum traceeval_data_type	type;
> > > 	size_t				flags;
> > > 	size_t				id;
> > > 	traceeval_dyn_release_fn	dyn_release;
> > > 	traceeval_dyn_cmp_fn		dyn_cmp;
> > > };
> > > 
> > > Especially since dynamic types are going to be rare, we don't want it in
> > > the hot cache.  
> > 
> > Does the order of the fields in a struct definition not matter? I
> > thought word-boundaries applied to struct definitions? Or does the
> > compiler take care of this?
> 
> They do matter. Word bounders are important, but the compiler will just
> make "holes" if needed. For example, let's say on 64 bit, everything above
> is 64 bits but the type. I would have created a "hole". But because the
> type is more important than the id, I kept it at the top.
> 
> struct traceeval_type {
> 	char				*name;			// offset 0
>  	enum traceeval_data_type	type;			// offset 8
> 
> [ compiler adds 4 byte "hole" or "padding" ]
> 
>  	size_t				flags;			// offset 16
>  	size_t				id;			// offset 24
>  	traceeval_dyn_release_fn	dyn_release;		// offset 32
>  	traceeval_dyn_cmp_fn		dyn_cmp;		// offset 40
> };
> 
> If a cache line is 32 bytes (most is usually 128, but let's say on an older
> architecture) I don't care if the the dyn_release and dyn_cmp are in the
> same cache line as name.
> 
> -- Steve

This makes sense, I appreciate the explination! I was treating size_t as
an int in my head by accident.... oops!

-- Stevie
