Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B49C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 12:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354470AbiASM7Z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 07:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbiASM7Y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 07:59:24 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5712CC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 04:59:24 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id n8so2101300plc.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 04:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C9RMVVl/8ig9wExu+EI4ZreTUIIt5kKzWdXQFxln3JI=;
        b=FHDh3wISjEhLy4qQN1xWnIyv9hx90S1xRkMOHhHe/AdPkQkzUq+ZAClu7XNadwa96P
         5imZSoXf7jkEXcwnX5rG4AYedoKmac1UsTSwLqX7sfyQx0TQmIBfosUxQGZAGJOmsJ1W
         dkzBMSSxdPglx59H39Rm8gbdSIwfosUs3dZvCjuahUGfuEsZgW95Yyi6Wl1o8rBZ3afI
         YUxXh+yWovc4R1FWQNiyYlgrEqa/5zmdgCwfd5Ux3EaVpEMCOLp2nLHYNu4XQe6L7LT+
         I0oId/Wfpk8dErPoAF4uMMUZloR7hPqaZSbWJ4xDP2g5O3dNCHQK/Dqt7YJE6pZIWruI
         W4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C9RMVVl/8ig9wExu+EI4ZreTUIIt5kKzWdXQFxln3JI=;
        b=nKoN+01KXeFcDpdwJBWf/1PcOXhfO917QL7YWETkFANwkQNSLrhCPk26FsRUxmSLPP
         9gJAHhFxaEbszHkE4SCk1AFTvGY1JoviNZ0ig/ZYQRhVmGK5PGdw2fnGFtixJmKXEk4A
         rFPoTREbU6TjLSut0cNM/JQo2ohNebHtYMDwAIk3lDn1JdBdhNrD7muFA7pmNkpapIgV
         ixzjyL3Jk6vk/7XP+z4P4yxCaBb7kjJfptnmHQGLFSN/wJip4cakCtkZvuUy0ze2FAjn
         zOc10lqwvnKeR8TuIOZC94bkgj/bh94lYpGaLbiZNo837Jhn0eTj8oQME9q8x6bsxkI4
         9Gfw==
X-Gm-Message-State: AOAM533N17VdMzu6SxcSSVhDnxrWa8bdgZ8d33A+ndYPoLn3in5mJVw1
        HDJn/zF0kLm5fhwfQ7QXfw31RrfSsUnKHTbadx1lNdhXmCU=
X-Google-Smtp-Source: ABdhPJxMz5XSlXag78r6Ibk0Lxf+Xwkq07eULVx4p8LmhWLIdNymOBTYDtrCciaz/RIfb+E7qPYpKbulw7eH3nUun4Y=
X-Received: by 2002:a17:902:d50d:b0:14a:4ed2:2a18 with SMTP id
 b13-20020a170902d50d00b0014a4ed22a18mr32766313plg.44.1642597163717; Wed, 19
 Jan 2022 04:59:23 -0800 (PST)
MIME-Version: 1.0
References: <20220118030005.1603821-1-rostedt@goodmis.org> <20220118030005.1603821-2-rostedt@goodmis.org>
In-Reply-To: <20220118030005.1603821-2-rostedt@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 19 Jan 2022 14:59:07 +0200
Message-ID: <CAPpZLN4n=L-ZHCXM+LDRiQu0XwR4iCnGeCKJOuOWenkz2EhESA@mail.gmail.com>
Subject: Re: [PATCH 1/2] libtracefs: Add tracefs_instance_get_affinity() APIs
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jan 19, 2022 at 2:02 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Add the APIs:
>
>   tracefs_instance_get_affinity()
>   tracefs_instance_get_affinity_set()
>   tracefs_instance_get_affinity_raw()
>
> These functions can retrieve the CPU affinity that denotes what an
> instance (or toplevel) has for CPUs that are enabled for tracing.
>
> The first API returns a nice human readable list of CPUs:
>
>  "1,4,6-8"
>
> To denote CPUs 1,4,6,7,8
>
> The _set() version uses CPU_SETS and the _raw() version just reads
> directly from the tracing_cpumask file.
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  .../libtracefs-instances-affinity.txt         |  39 +++-
>  include/tracefs.h                             |   4 +
>  src/tracefs-instance.c                        | 192 ++++++++++++++++++
>  3 files changed, 231 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/libtracefs-instances-affinity.txt b/Documentation/libtracefs-instances-affinity.txt
> index c5fa2d8b820c..22994f877e30 100644
> --- a/Documentation/libtracefs-instances-affinity.txt
> +++ b/Documentation/libtracefs-instances-affinity.txt
> @@ -3,8 +3,9 @@ libtracefs(3)
>
>  NAME
>  ----
> -tracefs_instance_set_affinity, tracefs_instance_set_affinity_set, tracefs_set_affinity_raw -
> -Sets the affinity for an instance or top level for what CPUs enable tracing.
> +tracefs_instance_set_affinity, tracefs_instance_set_affinity_set, tracefs_set_affinity_raw,
> +tracefs_instance_get_affinity, tracefs_instance_get_affinity_set, tracefs_get_affinity_raw,
> +Sets or retrieves the affinity for an instance or top level for what CPUs enable tracing.
>
>  SYNOPSIS
>  --------
> @@ -16,11 +17,14 @@ int *tracefs_instance_set_affinity*(struct tracefs_instance pass:[*]_instance_,
>  int *tracefs_instance_set_affinity_set*(struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_set_, size_t _set_size_);
>  int *tracefs_instance_set_affinity_raw*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_mask_);
>
> +char pass:[*]*tracefs_instance_get_affinity*(struct tracefs_instance pass:[*]_instance_);
> +int *tracefs_instance_get_affinity_set*(struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_set_, size_t _set_size_);
> +char pass:[*]*tracefs_instance_get_affinity_raw*(struct tracefs_instance pass:[*]_instance_);

These should be added also into Documentation/libtracefs.txt, under
the relevant API section. All library APIs should be listed there.

>  --
>
>  DESCRIPTION
>  -----------
> -These functions set the CPU affinity that limits what CPUs will have tracing enabled
> +These functions set or retrieves the CPU affinity that limits what CPUs will have tracing enabled

Maybe "These functions set or retrieve ..." ?

>  for a given instance defined by the _instance_ parameter. If _instance_ is NULL, then
>  the top level instance is affected.
>
> @@ -47,9 +51,32 @@ machine with more that 32 CPUs, to set CPUS 1-10 and CPU 40:
>
>  Where the above is a hex representation of bits 1-10 and bit 40 being set.
>
> +The *tracefs_instance_get_affinity()* will retrieve the affinity in a human readable
> +form.
> +
> +For example: "1,4,6-8"
> +
> +The string returned must be freed with *free*(3).
> +
> +The *tracefs_instance_get_affinity_set()* will set all the bits in the passed in
> +cpu set (from *CPU_SET*(3)). Note it will not clear any bits that are already set
> +in the set but the CPUs are not. If only the bits for the CPUs that are enabled
> +should be set, a CPU_ZERO_S() should be performed on the set before calling this
> +function.
> +
> +The *tracefs_instance_get_affinity_raw()* will simply read the instance tracing_cpumask
> +and return that string. The returned string must be freed with *free*(3).
> +
>  RETURN VALUE
>  ------------
> -All of these functions return 0 on success and -1 on error.
> +All the set functions return 0 on success and -1 on error.
> +
> +The functinos *tracefs_instance_get_affinity()* and *tracefs_instance_get_affinity_raw()*

a typo, "functions"

> +returns an allocated string that must be freed with *free*(3), or NULL on error.
> +
> +The function *tracefs_instance_get_affinity_set()* returns the number of CPUs that
> +were found set, or -1 on error.
> +
>
>  ERRORS
>  ------
> @@ -88,6 +115,10 @@ int main (int argc, char **argv)
>         int cpu2;
>         int i;
>
> +       c = tracefs_instance_get_affinity(NULL);
> +       printf("The affinity was %s\n", c);
> +       free(c);
> +
>         if (argc < 2) {
>                 tracefs_instance_set_affinity(NULL, NULL);
>                 exit(0);
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 9c53b8413795..1848ad0aa668 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -49,6 +49,10 @@ int tracefs_instance_set_affinity_raw(struct tracefs_instance *instance,
>                                       const char *mask);
>  int tracefs_instance_set_affinity(struct tracefs_instance *instance,
>                                   const char *cpu_str);
> +char *tracefs_instance_get_affinity(struct tracefs_instance *instance);
> +char *tracefs_instance_get_affinity_raw(struct tracefs_instance *instance);
> +int tracefs_instance_get_affinity_set(struct tracefs_instance *instance,
> +                                     cpu_set_t *set, size_t set_size);
>  char **tracefs_instances(const char *regex);
>
>  bool tracefs_instance_exists(const char *name);
> diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
> index fab615eb49ca..2d825b0e3bd0 100644
> --- a/src/tracefs-instance.c
> +++ b/src/tracefs-instance.c
> @@ -10,6 +10,7 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <unistd.h>
> +#include <ctype.h>
>  #include <errno.h>
>  #include <sys/stat.h>
>  #include <fcntl.h>
> @@ -974,3 +975,194 @@ int tracefs_instance_set_affinity(struct tracefs_instance *instance,
>         CPU_FREE(set);
>         return ret;
>  }
> +
> +/**
> + * tracefs_instance_get_affinity_raw - read the affinity instance file
> + * @instance: The instance to get affinity of (NULL for top level)
> + *
> + * Reads the affinity file for @instance (or the top level if @instance
> + * is NULL) and returns it. The returned string must be freed with free().
> + *
> + * Returns the affinity mask on success, and must be freed with free()
> + *   or NULL on error.
> + */
> +char *tracefs_instance_get_affinity_raw(struct tracefs_instance *instance)
> +{
> +       return tracefs_instance_file_read(instance, "tracing_cpumask", NULL);
> +}
> +
> +static inline int update_cpu_set(int cpus, int cpu_set, int cpu,
> +                                cpu_set_t *set, size_t set_size)
> +{
> +       int bit = 1 << cpu;
> +
> +       if (!(cpus & bit))
> +               return 0;
> +
> +       CPU_SET_S(cpu_set + cpu, set_size, set);
> +       return 1;
> +}
> +
> +/**
> + * tracefs_instance_get_affinity_set - Retrieve the cpuset of an instance affinity
> + * @instance: The instance to get affinity of (NULL for top level)
> + * @set: A CPU set to put the affinity into.
> + * @set_size: The size in bytes of @set (use CPU_ALLOC_SIZE() to get this value)
> + *
> + * Reads the affinity of a given instance and updates the CPU set by the
> + * instance.
> + *
> + * Returns the number of CPUS that are set, or -1 on error.
> + */
> +int tracefs_instance_get_affinity_set(struct tracefs_instance *instance,
> +                                     cpu_set_t *set, size_t set_size)
> +{
> +       char *affinity;
> +       int cpu_set;
> +       int cpus;
> +       int cnt = 0;
> +       int ch;
> +       int i;
> +
> +       if (!set || !set_size) {
> +               errno = -EINVAL;
> +               return -1;
> +       }
> +
> +       affinity = tracefs_instance_get_affinity_raw(instance);
> +       if (!affinity)
> +               return -1;
> +
> +       /*
> +        * The returned affinity should be a comma delimited
> +        * hex string. Work backwards setting the values.
> +        */
> +       cpu_set = 0;
> +       i = strlen(affinity);
> +       for (i--; i >= 0; i--) {
> +               ch = affinity[i];
> +               if (isalnum(ch)) {
> +                       ch = tolower(ch);
> +                       if (isdigit(ch))
> +                               cpus = ch - '0';
> +                       else
> +                               cpus = ch - 'a' + 10;
> +
> +                       cnt += update_cpu_set(cpus, cpu_set, 0, set, set_size);
> +                       cnt += update_cpu_set(cpus, cpu_set, 1, set, set_size);
> +                       cnt += update_cpu_set(cpus, cpu_set, 2, set, set_size);
> +                       cnt += update_cpu_set(cpus, cpu_set, 3, set, set_size);
> +                       /* Next nibble */
> +                       cpu_set += 4;

I think there should be a check if set_size is reached. I do not know
how CPU_SET_S is implemented and if it can handle cpu IDs bigger than
the set_size. That should never happen, but a check inside the loop is
useful just to be on the safe side.

> +               }
> +       }
> +
> +       free(affinity);
> +
> +       return cnt;
> +}
> +
> +static inline int update_cpu(int cpus, int cpu_set, int cpu, int s, char **set)
> +{
> +       char *list;
> +       int bit = 1 << cpu;
> +       int ret;
> +
> +       if (*set == (char *)-1)
> +               return s;
> +
> +       if (cpus & bit) {
> +               /* If the previous CPU is set just return s */
> +               if (s >= 0)
> +                       return s;
> +               /* Otherwise, return this cpu */
> +               return cpu_set + cpu;
> +       }
> +
> +       /* If the last CPU wasn't set, just return s */
> +       if (s < 0)
> +               return s;
> +
> +       /* Update the string */
> +       if (s == cpu_set + cpu - 1) {
> +               ret = asprintf(&list, "%s%s%d",
> +                              *set ? *set : "", *set ? "," : "", s);
> +       } else {
> +               ret = asprintf(&list, "%s%s%d-%d",
> +                              *set ? *set : "", *set ? "," : "",
> +                              s, cpu_set + cpu - 1);
> +       }
> +       free(*set);
> +       /* Force *set to be a failure */
> +       if (ret < 0)
> +               *set = (char *)-1;
> +       else
> +               *set = list;
> +       return -1;
> +}
> +
> +/**
> + * tracefs_instance_get_affinity - Retrieve a string of CPUs for instance affinity
> + * @instance: The instance to get affinity of (NULL for top level)
> + *
> + * Reads the affinity of a given instance and returns a CPU count of the
> + * instance. For example, if it reads "eb" it will return:
> + *      "0-1,3,5-7"
> + *
> + * If no CPUs are set, an empty string is returned "\0", and it too needs
> + * to be freed.
> + *
> + * Returns an allocate string containing the CPU affinity in "human readable"

Maybe that should be "Returns an allocated string ..." ?

> + *  format which needs to be freed with free(), or NULL on error.
> + */
> +char *tracefs_instance_get_affinity(struct tracefs_instance *instance)
> +{
> +       char *affinity;
> +       char *set = NULL;
> +       int cpu_set;
> +       int cpus;
> +       int ch;
> +       int s = -1;
> +       int i;
> +
> +       affinity = tracefs_instance_get_affinity_raw(instance);
> +       if (!affinity)
> +               return NULL;
> +
> +       /*
> +        * The returned affinity should be a comma delimited
> +        * hex string. Work backwards setting the values.
> +        */
> +       cpu_set = 0;
> +       i = strlen(affinity);
> +       for (i--; i >= 0; i--) {
> +               ch = affinity[i];
> +               if (isalnum(ch)) {
> +                       ch = tolower(ch);
> +                       if (isdigit(ch))
> +                               cpus = ch - '0';
> +                       else
> +                               cpus = ch - 'a' + 10;
> +                       s = update_cpu(cpus, cpu_set, 0, s, &set);
> +                       s = update_cpu(cpus, cpu_set, 1, s, &set);
> +                       s = update_cpu(cpus, cpu_set, 2, s, &set);
> +                       s = update_cpu(cpus, cpu_set, 3, s, &set);
> +
> +                       if (set == (char *)-1) {
> +                               set = NULL;
> +                               goto out;
> +                       }
> +                       /* Next nibble */
> +                       cpu_set += 4;
> +               }
> +       }
> +       /* Clean up in case the last CPU is set */
> +       s = update_cpu(0, cpu_set, 0, s, &set);
> +
> +       if (!set)
> +               set = strdup("");
> + out:
> +       free(affinity);
> +
> +       return set;
> +}
> --
> 2.33.0
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
