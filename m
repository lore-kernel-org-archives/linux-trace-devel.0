Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C725C001B0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 21:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjHHVvJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 17:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjHHVvJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 17:51:09 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995E4B1
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 14:51:08 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-407ff54164dso40337951cf.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Aug 2023 14:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691531468; x=1692136268;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4ws0rQi6Goqb5YSAFl+KukERlUmSo4lPzm76sACg9+o=;
        b=TAyzSvw5a+kAJHiCRcWh7q2U/C5voBrKSJPuFthu/Uu2SZ1nUJ6zx9ruPgfMRTpFRH
         d0xFLW22cAr1JYz4SvBMjr7N0Ha04yvP4771TSi3mo8iwj3QqpXkkJgxSclrfO4anojx
         4BJI1uifXtxmTTiyAiz8T2wqXuFnjTzxedpqEBPAsI/FLKcWPfsFVOZEBi8SNxvJmLKG
         EuwlZPdqqtflqogaOuztTOuafZ4ZNFs3zGRBd8WGctFw3N4pj9lIax4biVBIF8mNsEB6
         v/t5GLTQ6uj1tgXl9YGmQ4xx+eMSvnElU3sEkHMGgj4dnfn/DNWFXb2O29BkNtK+MEbO
         3+3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691531468; x=1692136268;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ws0rQi6Goqb5YSAFl+KukERlUmSo4lPzm76sACg9+o=;
        b=jkHbv51DFE56dCQZVIwfkZnuRojy1Dr/dcbkiYyD1PKJswGIjHppFGm8hqXoIJmqVH
         FF62O4nmohDbQd8T+gg0yFJvsMJ9ZckXWB5ji4Y9UnMiWoynoqMcJlyU1sYlnhq1JpIV
         rRJdomhpcxZUuM97OCPuSBWfobcpznoAgJiOZHFaQYjj7LgT0oL2k9RigR3uC92IDv3B
         7UWGJMI1T/znU5XuAbCo+9rbmAk/2BbroMAoRz9bOBDZUwsQ8SdC5csTOuECW4jWJ3F2
         dg+54CHiIqhdusWuRQZRKQeFkyNbPanbgqy83VxnkRPl/GhENxS3ItYYVH62hMANYyxq
         gqkA==
X-Gm-Message-State: AOJu0YzXI7GtFfKDF1S1iId0gTCFhupMzvjilZYSdnfsdadzZXDodxJO
        B2mNWdZrvhber50JF12R0ZA=
X-Google-Smtp-Source: AGHT+IHowhYvYdGCLhhukBCSz6sjuHXRBGNC8KUVKO0w4T3NZ+vmhwRBFl5bObOS69IwFuk4d21P4Q==
X-Received: by 2002:ac8:5954:0:b0:403:ae78:1517 with SMTP id 20-20020ac85954000000b00403ae781517mr1034440qtz.30.1691531467662;
        Tue, 08 Aug 2023 14:51:07 -0700 (PDT)
Received: from 3xKetch ([2601:180:8300:500::6aa8])
        by smtp.gmail.com with ESMTPSA id 3-20020ac85743000000b0040f8ac751a5sm3630881qtx.96.2023.08.08.14.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 14:51:07 -0700 (PDT)
Date:   Tue, 8 Aug 2023 17:51:05 -0400
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v3 1/6] histograms: Initial histograms interface
Message-ID: <20230808215105.GA1258@3xKetch>
References: <20230808161204.5704-1-stevie.6strings@gmail.com>
 <20230808161204.5704-2-stevie.6strings@gmail.com>
 <20230808153547.29b7bc60@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808153547.29b7bc60@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Aug 08, 2023 at 03:35:47PM -0400, Steven Rostedt wrote:
> On Tue,  8 Aug 2023 12:11:54 -0400
> Stevie Alvarez <stevie.6strings@gmail.com> wrote:
> 
> > +/*
> > + * Trace data entry for a traceeval histogram
> > + * Constitutes keys and values.
> > + */
> > +union traceeval_data {
> > +	char				*string;
> 
> We need to also add:
> 
> 	const char			*cstring;
> 
> At least for the user interface, as I'm converting task-eval over to this,
> and I need to assign const strings to this union.

I assume I should treat cstring the same as string, execept because it's
constant, it should not be updated on insertion, correct?

-- Stevie
> 
> -- Steve
> 
> > +	struct traceeval_dynamic	*dyn_data;
> > +	unsigned long long		number_64;
> > +	unsigned long			number;
> > +	unsigned int			number_32;
> > +	unsigned short			number_16;
> > +	unsigned char			number_8;
> > +};
> > +
