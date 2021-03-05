Return-Path: <SRS0=uRrw=ID=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E2FC433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 14:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B66264FD2
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 14:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhCEOkG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 09:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231283AbhCEOjs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 09:39:48 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AD0264F34;
        Fri,  5 Mar 2021 14:39:48 +0000 (UTC)
Date:   Fri, 5 Mar 2021 09:39:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
Message-ID: <20210305093946.1c3f4ad7@gandalf.local.home>
In-Reply-To: <CAPpZLN6A+5pmCnOCJfg-eV1+1UR_MbwgvzhW-bd-ZZJ1F-dC=A@mail.gmail.com>
References: <1615029625-9749-1-git-send-email-sameeruddin.shaik8@gmail.com>
        <CAPpZLN6A+5pmCnOCJfg-eV1+1UR_MbwgvzhW-bd-ZZJ1F-dC=A@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 5 Mar 2021 14:20:15 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > +               if (module)
> > +                       write_size = snprintf(each_str, slen, "%s:mod:%s ", filters[i], module);
> > +               else
> > +                       write_size = snprintf(each_str, slen, "%s ", filters[i]);
> > +
> > +               size = write(fd, each_str, write_size);
> > +               /* compare written bytes and also compare the written bytes with difference of added 5 bytes to string for ":mod:"*/
> > +               if ((size < write_size) && (size < (write_size - 5))) {  
> 
> The second comparison is not needed, the size must be equal to
> write_size in case of success.
> 
> > +                       errs[j++] = filters[i];  
> 
> The errs must be (re)allocated here, to hold additional pointer
> to string. The user does not know in advance the number of
> failed filters and it is not expected to provide an already
> allocated array. So it should be a triple pointer.
> 
> It is OK to assign directly failed input string to the error array,
> but this should be written in the API description, i.e. the user
> should not free the strings from the @errs array as it is a subset
> of the @filters array, or something like that. But note, the user
> still must free the @errs itself.

A check to see if "errs" is NULL is needed too. If the user doesn't care
about the errors, they can pass in NULL to errs, in which case, they should
be ignored.

> 
> > +                       ret -= 1;
> > +               }
> > +               free(each_str);
> > +       }
> > +       errs[j] = NULL;
> > +       close(fd);
> > +       return ret;
> > +}
> > +
> > +/**
> > + * tracefs_function_filter - write to set_ftrace_filter file to trace particular functions
> > + * @instance: ftrace instance, can be NULL for top tracing instance
> > + * @filters: An array of function names ending with a NULL pointer
> > + * @module: Module to be traced
> > + * @reset: set to true to reset the file before applying the filter
> > + * @errs: An Array of failed function names ending with a NULL pointer

Thus the description for @errs should be:

 @errs: A pointer to an array of const strings that will be allocated on
        a negative return of this function, pointing to the filters that
        failed. May be NULL, in which case this field will be ignored.

> > + *
> > + * The @filters is an array of strings, where each string will be used to set
> > + * a function or functions to be traced.
> > + *
> > + * If @reset is true, then all functions in the filter are cleared before
> > + * adding functions from @filter. Otherwise, the functions set by @filter
> > + * will be appended to the filter file
> > + *
> > + * The @errs is an array of strings, where each string is a failed function
> > + * name
> > + *
> > + * returns -x (where x is number of failed filter srtings or it can be
> > + * 1 for general errors), or 0 if there are no errors.
> > + */
> > +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char **errs)

Note, @filters should be of type: const char * const * filters,  as not
only is filters pointing to constant strings, the array itself will not be
modified. And errs, should be of type: const char ***errs. Where it will be
allocated.

Since a triple pointer is difficult to manage in the code, you could have:

	const char **e = NULL;

	
		if (errs) {
			e = realloc(sizeof(*e), j + 1);
			e[j++] = filters[i];
		}

Then at the end:

	if (errs)
		*errs = e;


> > +{
> > +       char *ftrace_filter_path;
> > +       int ret = 0;  
> 
> This should be initialised to the error return code, to ensure that
> every "goto out" will return error.
> 
> > +
> > +       if (!filters)
> > +               return -1;  
> 
> Should return 1, according to the API description.
> 
> > +
> > +       ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
> > +       if (!ftrace_filter_path)
> > +               goto out;  
> 
> "ret" is 0 here, so success will be returned, which is not the desired
> behaviour.
> "ftrace_filter_path" is NULL and the tracefs_put_tracing_file()
> will be called with NULL, but this is OK, should not be a problem.

It shouldn't be a problem, but it is also fine to return directly here.

	if (!ftrace_filter_path)
		return 1;

Thanks!

-- Steve

> 
> > +
> > +       ret = controlled_write(ftrace_filter_path, filters, module, reset, errs);
> > + out:
> > +       tracefs_put_tracing_file(ftrace_filter_path);
> > +       return ret;
> > +}
> > --
> > 2.7.4
> >  
> 
> It is a good starting point, thanks for sending this patch Sameer!
> 

