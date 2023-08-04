Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C702C001DB
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Aug 2023 17:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjHDRmI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjHDRmH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 13:42:07 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA1A49F3
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 10:42:06 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bc34b32785so17089265ad.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 04 Aug 2023 10:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691170925; x=1691775725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KOyEBQ4sKdJOppRZIZt0cEy+vpqsvUiczCvc0gaSbdk=;
        b=fecHNUO53kR5j3nQz7DAX0f64NMgzm6dpmMYxb7Po+ZBSFpC7+vDdt7cNvj5Q2QERz
         BjJAOizSn/terObkENCj4zkMzm6ZSRRgrgleFuovIRQCoNmsPKHGqO6J1M3AvopwQw/B
         OgcAx+ihX5rHSuJ41tkhlsLVAoSpvc1TqUcF0oaYTKymZ3Ny8K0l9Rv2wURbpqVF0D67
         sJydD+61+4njlQB4H74+LPYUksHhbVU5W2z3FAlwDpo+hKhV6zUK2pDUUK8bon7z9bDC
         D/xcAAkM3NB/pRdTk73J6xfpMKjw5esResfEngz6FtFDfCjEGFx2vQo4Jwb5ACWlJplI
         1mlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691170925; x=1691775725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KOyEBQ4sKdJOppRZIZt0cEy+vpqsvUiczCvc0gaSbdk=;
        b=I5rbqd0AfPfjCuS6TVsT4ob7rsJWU+yQXe3XVgtmZBBX3rVARYVRfnHQZvYTyvDWxr
         RmE2rWpDCyTWjMzKFDdHqvUs9I9KcZvBGvTLGt+xWxffZFsf+6gW5pEvI7AqfnC5oQOf
         S1QjmhbsV79g4APKNJHhCt1INumg8SFgT8DBuo+h+5fel4fVYXcROQvW0VHg0Oj2/Jgs
         Pe9wIb0TvTzGTf+dRwFplAXMYlMJUsRi77cVGLRJojJejgJoLL/sFcQnWz8kScjvxZj+
         pHb9iJzrvtQR2bdjxp3MtFYrnZxubda7eWEYDWPTctDfF0AZLmWbcR9wS/0VKBNkSdNd
         OBtw==
X-Gm-Message-State: AOJu0Yx4G3wUHzeCFmXf7dzD05uf8Z7RgeTVqAE6c67GR8fX140I3Acy
        vsaY2WZFhex3/DkDDILa6bc=
X-Google-Smtp-Source: AGHT+IHXcruw6+6ulVTw/9hrb25N1nRha8QNRU1zybMcf0iciCRWk3VX+wdJeZbL/8UGTYIzUnDz+g==
X-Received: by 2002:a17:902:b90c:b0:1bc:4f77:e34f with SMTP id bf12-20020a170902b90c00b001bc4f77e34fmr1798614plb.27.1691170925302;
        Fri, 04 Aug 2023 10:42:05 -0700 (PDT)
Received: from 3xKetch ([2601:600:a17f:b422::ffc])
        by smtp.gmail.com with ESMTPSA id ju18-20020a170903429200b001b86e17ecacsm2025449plb.131.2023.08.04.10.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 10:42:04 -0700 (PDT)
Date:   Fri, 4 Aug 2023 13:41:59 -0400
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v2 1/5] histograms: Initial histograms interface
Message-ID: <20230804174159.GA2510@3xKetch>
References: <20230803225413.40697-1-stevie.6strings@gmail.com>
 <20230803225413.40697-2-stevie.6strings@gmail.com>
 <20230804095058.756fccb0@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230804095058.756fccb0@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Aug 04, 2023 at 09:50:58AM -0400, Steven Rostedt wrote:
> On Thu,  3 Aug 2023 18:53:59 -0400
> Stevie Alvarez <stevie.6strings@gmail.com> wrote:
> 
> > From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>
> > 
> > Initial header file for libtraceeval's histogram API. The interface
> > provides a simple way of aggregating trace data and reading through said
> > data.
> > 
> > Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> > ---
> >  include/traceeval-hist.h | 128 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 128 insertions(+)
> >  create mode 100644 include/traceeval-hist.h
> > 
> > diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> > new file mode 100644
> > index 0000000..4664974
> > --- /dev/null
> > +++ b/include/traceeval-hist.h
> > @@ -0,0 +1,128 @@
> > +/* SPDX-License-Identifier: MIT */
> > +/*
> > + * libtraceeval histogram interface.
> > + *
> > + * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
> > + * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
> > + */
> > +#ifndef __LIBTRACEEVAL_HIST_H__
> > +#define __LIBTRACEEVAL_HIST_H__
> > +
> > +#include <stdlib.h>
> > +#include <stddef.h>
> > +#include <stdbool.h>
> > +
> > +/* Data definition interfaces */
> > +
> > +/* Field name/descriptor for number of hits */
> > +#define TRACEEVAL_VAL_HITS ((const char *)(-1UL))
> > +
> > +/* Data type distinguishers */
> > +enum traceeval_data_type {
> > +	TRACEEVAL_TYPE_NONE,
> > +	TRACEEVAL_TYPE_STRING,
> > +	TRACEEVAL_TYPE_NUMBER,
> > +	TRACEEVAL_TYPE_NUMBER_64,
> > +	TRACEEVAL_TYPE_NUMBER_32,
> > +	TRACEEVAL_TYPE_NUMBER_16,
> > +	TRACEEVAL_TYPE_NUMBER_8,
> 
> Hmm, I'm thinking it would be nice to rearrange this a bit to:
> 
> enum traceeval_data_type {
> 	TRACEEVAL_TYPE_NONE,
> 	TRACEEVAL_TYPE_NUMBER_8,
> 	TRACEEVAL_TYPE_NUMBER_16,
> 	TRACEEVAL_TYPE_NUMBER_32,
> 	TRACEEVAL_TYPE_NUMBER_64,
> 	TRACEEVAL_TYPE_NUMBER,
> 	TRACEEVAL_TYPE_STRING,
> 
> That way NUMBER_8 will be 1, NUMBER_16 is 2, NUMBER_32 is 3 and NUMBER_64
> is 4. If we ever wanted to do a trick, we can get the byte size from:
> 
>   2^(1 * (enum - 1))
> 
>   2^(1 * (NUMBER_8 - 1))  = 2^(1 * 0) = 1
>   2^(1 * (NUMBER_16 - 1)) = 2^(1 * 1) = 2
>   2^(1 * (NUMBER_32 - 1)) = 2^(1 * 2) = 4
>   2^(1 * (NUMBER_64 - 1)) = 2^(1 * 3) = 8
> 
> I love hacks!
> 
> 
> > +	TRACEEVAL_TYPE_DYNAMIC
> > +};
> > +
> > +/* Statistics specification flags */
> > +enum traceeval_flags {
> > +	TRACEEVAL_FL_SIGNED		= (1 << 0),
> > +	TRACEEVAL_FL_TIMESTAMP		= (1 << 1),
> > +	TRACEEVAL_FL_STATS		= (1 << 2)
> 
> We may as well remove STATS until we decided to use it.
> 
> Maybe even get rid of this enum until we decide to use it.
> 
> Remember, once it's exposed, it is API.
> 
> > +};
> > +
> > +/*
> > + * Trace data entry for a traceeval histogram
> > + * Constitutes keys and values.
> > + */
> > +union traceeval_data {
> > +	char				*string;
> > +	struct traceeval_dynamic	*dyn_data;
> > +	unsigned long long		number_64;
> > +	unsigned long			number;
> > +	unsigned int			number_32;
> > +	unsigned short			number_16;
> > +	unsigned char			number_8;
> > +};
> > +
> > +/*
> > + * struct traceeval_dynamic - Storage for dynamic traceeval_types
> > + * @size: The size of the dynamic type
> > + * @data: The pointer to the data of the dynamic type
> > + */
> > +struct traceeval_dynamic {
> > +	void		*data;
> > +	size_t		size;
> > +};
> > +
> 
> As I replied to the cover letter, you need to add:
> 
> struct traceeval_type;
> 
> to get rid of the warning.
> 
> > +/* struct traceeval_dynamic release function signature */
> > +typedef void (*traceeval_dyn_release_fn)(struct traceeval_dynamic *,
> > +		struct traceeval_type *);
> > +
> > +/* struct traceeval_dynamic compare function signature */
> > +typedef int (*traceeval_dyn_cmp_fn)(struct traceeval_dynamic *,
> > +		struct traceeval_dynamic *, struct traceeval_type *);
> > +
> > +/*
> > + * struct traceeval_type - Describes the type of a traceevent_data instance
> > + * @type: The enum type that describes the traceeval_data
> > + * @name: The string name of the traceeval_data
> > + * @flags: flags to describe the traceeval_data
> > + * @id: User specified identifier
> > + * @dyn_release: For dynamic types called on release (ignored for other types)
> > + * @dyn_cmp: A way to compare dynamic types (ignored for other types)
> > + *
> > + * The traceeval_type structure defines expectations for a corresponding
> > + * traceeval_data instance for a traceeval histogram instance. Used to
> > + * describe both keys and values.
> > + *
> > + * The @id field is an optional value in case the user has multiple struct
> > + * traceeval_type instances with @type fields set to TRACEEVAL_TYPE_DYNAMIC,
> > + * which each relate to distinct user defined struct traceeval_dynamic
> > + * 'sub-types'.
> > + *
> > + * For flexibility, @dyn_cmp() and @dyn_release() take a struct
> > + * traceeval_type instance. This allows the user to distinguish between
> > + * different sub-types of struct traceeval_dynamic within a single
> > + * callback function by examining the @id field. This is not a required
> > + * approach, merely one that is accommodated.
> > + *
> > + * @dyn_cmp() is used to compare two struct traceeval_dynamic instances when a
> > + * corresponding struct traceeval_type is reached with its type field set to
> > + * TRACEEVAL_TYPE_DYNAMIC. It should return 0 on equality, 1 if the first
> > + * argument is greater than the second, -1 for the other way around, and -2 on
> > + * error.
> > + *
> > + * dyn_release() is used during traceeval_release() to release a union
> > + * traceeval_data's struct traceeval_dynamic field when the corresponding
> > + * traceeval_type type is set to TRACEEVAL_TYPE_DYNAMIC.
> > + */
> > +struct traceeval_type {
> > +	char				*name;
> > +	traceeval_dyn_release_fn	dyn_release;
> > +	traceeval_dyn_cmp_fn		dyn_cmp;
> > +	enum traceeval_data_type	type;
> > +	size_t				flags;
> > +	size_t				id;
> 
> Let's reorder this a little. Normally function pointers come at the end of
> a structure. That's more of a guideline than a rule, but let's have it here.
> 
> struct traceeval_type {
> 	char				*name;
> 	enum traceeval_data_type	type;
> 	size_t				flags;
> 	size_t				id;
> 	traceeval_dyn_release_fn	dyn_release;
> 	traceeval_dyn_cmp_fn		dyn_cmp;
> };
> 
> Especially since dynamic types are going to be rare, we don't want it in
> the hot cache.

Does the order of the fields in a struct definition not matter? I
thought word-boundaries applied to struct definitions? Or does the
compiler take care of this?

-- Stevie

> 
> -- Steve
> 
> 
> > +};
> > +
> > +/* Statistics about a given entry element */
> > +struct traceeval_stat {
> > +	unsigned long long	max;
> > +	unsigned long long	min;
> > +	unsigned long long	total;
> > +	unsigned long long	avg;
> > +	unsigned long long	std;
> > +};
> > +
> > +/* Iterator over aggregated data */
> > +struct traceeval_iterator;
> > +
> > +struct traceeval;
> > +
> > +#endif /* __LIBTRACEEVAL_HIST_H__ */
> 
