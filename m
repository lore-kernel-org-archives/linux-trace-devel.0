Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F02C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 15:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355823AbiASPkN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 10:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355749AbiASPkM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 10:40:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2665DC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 07:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E01BFB8197E
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 15:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D135C340E1;
        Wed, 19 Jan 2022 15:40:09 +0000 (UTC)
Date:   Wed, 19 Jan 2022 10:40:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/2] libtracefs: Add tracefs_instance_get_affinity()
 APIs
Message-ID: <20220119104007.63f8125f@gandalf.local.home>
In-Reply-To: <CAPpZLN4n=L-ZHCXM+LDRiQu0XwR4iCnGeCKJOuOWenkz2EhESA@mail.gmail.com>
References: <20220118030005.1603821-1-rostedt@goodmis.org>
        <20220118030005.1603821-2-rostedt@goodmis.org>
        <CAPpZLN4n=L-ZHCXM+LDRiQu0XwR4iCnGeCKJOuOWenkz2EhESA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 19 Jan 2022 14:59:07 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> >  SYNOPSIS
> >  --------
> > @@ -16,11 +17,14 @@ int *tracefs_instance_set_affinity*(struct tracefs_instance pass:[*]_instance_,
> >  int *tracefs_instance_set_affinity_set*(struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_set_, size_t _set_size_);
> >  int *tracefs_instance_set_affinity_raw*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_mask_);
> >
> > +char pass:[*]*tracefs_instance_get_affinity*(struct tracefs_instance pass:[*]_instance_);
> > +int *tracefs_instance_get_affinity_set*(struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_set_, size_t _set_size_);
> > +char pass:[*]*tracefs_instance_get_affinity_raw*(struct tracefs_instance pass:[*]_instance_);  
> 
> These should be added also into Documentation/libtracefs.txt, under
> the relevant API section. All library APIs should be listed there.

Agreed, I'll make a patch to add them.

> 
> >  --
> >
> >  DESCRIPTION
> >  -----------
> > -These functions set the CPU affinity that limits what CPUs will have tracing enabled
> > +These functions set or retrieves the CPU affinity that limits what CPUs will have tracing enabled  
> 
> Maybe "These functions set or retrieve ..." ?

Oops. Sure. I'll add a patch to fix that.

> 
> >  for a given instance defined by the _instance_ parameter. If _instance_ is NULL, then
> >  the top level instance is affected.
> >
> > @@ -47,9 +51,32 @@ machine with more that 32 CPUs, to set CPUS 1-10 and CPU 40:
> >
> >  Where the above is a hex representation of bits 1-10 and bit 40 being set.
> >
> > +The *tracefs_instance_get_affinity()* will retrieve the affinity in a human readable
> > +form.
> > +
> > +For example: "1,4,6-8"
> > +
> > +The string returned must be freed with *free*(3).
> > +
> > +The *tracefs_instance_get_affinity_set()* will set all the bits in the passed in
> > +cpu set (from *CPU_SET*(3)). Note it will not clear any bits that are already set
> > +in the set but the CPUs are not. If only the bits for the CPUs that are enabled
> > +should be set, a CPU_ZERO_S() should be performed on the set before calling this
> > +function.
> > +
> > +The *tracefs_instance_get_affinity_raw()* will simply read the instance tracing_cpumask
> > +and return that string. The returned string must be freed with *free*(3).
> > +
> >  RETURN VALUE
> >  ------------
> > -All of these functions return 0 on success and -1 on error.
> > +All the set functions return 0 on success and -1 on error.
> > +
> > +The functinos *tracefs_instance_get_affinity()* and *tracefs_instance_get_affinity_raw()*  
> 
> a typo, "functions"

Good catch.

> 
> > +returns an allocated string that must be freed with *free*(3), or NULL on error.
> > +
> > +The function *tracefs_instance_get_affinity_set()* returns the number of CPUs that
> > +were found set, or -1 on error.
> > +
> >
...

> > +/**
> > + * tracefs_instance_get_affinity_set - Retrieve the cpuset of an instance affinity
> > + * @instance: The instance to get affinity of (NULL for top level)
> > + * @set: A CPU set to put the affinity into.
> > + * @set_size: The size in bytes of @set (use CPU_ALLOC_SIZE() to get this value)
> > + *
> > + * Reads the affinity of a given instance and updates the CPU set by the
> > + * instance.
> > + *
> > + * Returns the number of CPUS that are set, or -1 on error.
> > + */
> > +int tracefs_instance_get_affinity_set(struct tracefs_instance *instance,
> > +                                     cpu_set_t *set, size_t set_size)
> > +{
> > +       char *affinity;
> > +       int cpu_set;
> > +       int cpus;
> > +       int cnt = 0;
> > +       int ch;
> > +       int i;
> > +
> > +       if (!set || !set_size) {
> > +               errno = -EINVAL;
> > +               return -1;
> > +       }
> > +
> > +       affinity = tracefs_instance_get_affinity_raw(instance);
> > +       if (!affinity)
> > +               return -1;
> > +
> > +       /*
> > +        * The returned affinity should be a comma delimited
> > +        * hex string. Work backwards setting the values.
> > +        */
> > +       cpu_set = 0;
> > +       i = strlen(affinity);
> > +       for (i--; i >= 0; i--) {
> > +               ch = affinity[i];
> > +               if (isalnum(ch)) {
> > +                       ch = tolower(ch);
> > +                       if (isdigit(ch))
> > +                               cpus = ch - '0';
> > +                       else
> > +                               cpus = ch - 'a' + 10;
> > +
> > +                       cnt += update_cpu_set(cpus, cpu_set, 0, set, set_size);
> > +                       cnt += update_cpu_set(cpus, cpu_set, 1, set, set_size);
> > +                       cnt += update_cpu_set(cpus, cpu_set, 2, set, set_size);
> > +                       cnt += update_cpu_set(cpus, cpu_set, 3, set, set_size);
> > +                       /* Next nibble */
> > +                       cpu_set += 4;  
> 
> I think there should be a check if set_size is reached. I do not know
> how CPU_SET_S is implemented and if it can handle cpu IDs bigger than
> the set_size. That should never happen, but a check inside the loop is
> useful just to be on the safe side.

So I actually thought about this, and ideally, the _S is suppose to handle
this. I read in the man page:

  The macros whose names end with "_S" are the analogs of the similarly
  named macros without the suffix.  These macros perform the same tasks as
  their analogs, but operate on the dynamically allocated CPU set(s) whose
  size is setsize bytes.

I took it as being something like strncpy() and strncmp() where the 'n'
means not to go beyond it.

Doing tests shows that it looks to do exactly that. But perhaps I should at
least not add the count if it doesn't get set. That should be easy enough
to add.


> 
> > +               }
> > +       }
> > +
> > +       free(affinity);
> > +
> > +       return cnt;
> > +}
> > +
> > +static inline int update_cpu(int cpus, int cpu_set, int cpu, int s, char **set)
> > +{
> > +       char *list;
> > +       int bit = 1 << cpu;
> > +       int ret;
> > +
> > +       if (*set == (char *)-1)
> > +               return s;
> > +
> > +       if (cpus & bit) {
> > +               /* If the previous CPU is set just return s */
> > +               if (s >= 0)
> > +                       return s;
> > +               /* Otherwise, return this cpu */
> > +               return cpu_set + cpu;
> > +       }
> > +
> > +       /* If the last CPU wasn't set, just return s */
> > +       if (s < 0)
> > +               return s;
> > +
> > +       /* Update the string */
> > +       if (s == cpu_set + cpu - 1) {
> > +               ret = asprintf(&list, "%s%s%d",
> > +                              *set ? *set : "", *set ? "," : "", s);
> > +       } else {
> > +               ret = asprintf(&list, "%s%s%d-%d",
> > +                              *set ? *set : "", *set ? "," : "",
> > +                              s, cpu_set + cpu - 1);
> > +       }
> > +       free(*set);
> > +       /* Force *set to be a failure */
> > +       if (ret < 0)
> > +               *set = (char *)-1;
> > +       else
> > +               *set = list;
> > +       return -1;
> > +}
> > +
> > +/**
> > + * tracefs_instance_get_affinity - Retrieve a string of CPUs for instance affinity
> > + * @instance: The instance to get affinity of (NULL for top level)
> > + *
> > + * Reads the affinity of a given instance and returns a CPU count of the
> > + * instance. For example, if it reads "eb" it will return:
> > + *      "0-1,3,5-7"
> > + *
> > + * If no CPUs are set, an empty string is returned "\0", and it too needs
> > + * to be freed.
> > + *
> > + * Returns an allocate string containing the CPU affinity in "human readable"  
> 
> Maybe that should be "Returns an allocated string ..." ?

Yep. Good catch.


-- Steve
