Return-Path: <SRS0=3JjO=2L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A776EC43603
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 Dec 2019 03:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70FFB20866
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 Dec 2019 03:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfLUDDf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 22:03:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:32892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbfLUDDf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 22:03:35 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB83E20716;
        Sat, 21 Dec 2019 03:03:34 +0000 (UTC)
Date:   Fri, 20 Dec 2019 22:03:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v18 04/18] trace-cmd: Add new library APIs for ftrace
 instances.
Message-ID: <20191220220332.517cb36f@rorschach.local.home>
In-Reply-To: <20191213153029.133570-5-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
        <20191213153029.133570-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 13 Dec 2019 17:30:15 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +/**
> + * tracecmd_get_instance_file - return the path to a instance file
> + * @instance: buffer instance for the file, can be NULL for the top instance
> + * @file: name of file to return
> + *
> + * Returns the path name of the @file for the given @instance
> + *
> + * Must use tracecmd_put_tracing_file() to free the returned string
> + */
> +char *
> +tracecmd_get_instance_file(struct tracecmd_instance *instance, const char *file)
> +{
> +	char *path;
> +	char *buf;
> +	int ret;
> +
> +	if (instance && instance->name) {
> +		ret = asprintf(&buf, "instances/%s/%s", instance->name, file);
> +		if (ret < 0)
> +			die("Failed to allocate name for %s/%s", instance->name, file);
> +		path = tracecmd_get_tracing_file(buf);
> +		free(buf);
> +	} else
> +		path = tracecmd_get_tracing_file(file);
> +
> +	return path;
> +}
> +
> +/**
> + * tracecmd_get_instance_file - return the path to a instance file
> + * @instance: buffer instance for the file, can be NULL for the top instance
> + * @file: name of file to return
> + *
> + * Returns the path name of the @file for the given @instance
> + *
> + * Must use tracecmd_put_tracing_file() to free the returned string

The above is a cut and paste of tracecmd_get_instance_file, not of the
instance_dir.

> + */
> +char *tracecmd_get_instance_dir(struct tracecmd_instance *instance)
> +{
> +	char *buf;
> +	char *path;
> +	int ret;
> +
> +	if (instance->name) {
> +		ret = asprintf(&buf, "instances/%s", instance->name);
> +		if (ret < 0)
> +			die("Failed to allocate for instance %s", instance->name);
> +		path = tracecmd_get_tracing_file(buf);
> +		free(buf);
> +	} else
> +		path = tracecmd_find_tracing_dir();
> +
> +	return path;
> +}
> +
> +/**
> + * tracecmd_write_instance_file - Write in trace file of specific instance
> + * @instance: buffer instance for the file, can be NULL for the top instance
> + * @file: name of the file
> + * @str: Nul terminated string, that will be written in the file
> + * @type: Nul terminated string, describing the current write operation
> + *	  Used for logging purposes
> + *
> + * Returns the number of written bytes, or -1 in case of an error
> + */
> +int tracecmd_write_instance_file(struct tracecmd_instance *instance,
> +				 const char *file, const char *str,
> +				 const char *type)

I think we should get rid of the type and move the logic that needs it
to the callers.


> +{
> +	struct stat st;
> +	char *path;
> +	int ret;
> +
> +	path = tracecmd_get_instance_file(instance, file);
> +	ret = stat(path, &st);
> +	if (ret == 0)
> +		ret = tracecmd_write_file(path, str, type);
> +	tracecmd_put_tracing_file(path);
> +
> +	return ret;
> +}
> +

[..]

> +/*
> + * tracecmd_write_file - Write in trace file
> + * @file: Full name of the trace file.
> + * @str: Null terminated string, that will be written in the file.
> + * @type: Null terminated string, describing the current write operation.
> + *	  Used for logging purposes.
> + *
> + * Returns the number of written bytes, or -1 in case of an error
> + */
> +int tracecmd_write_file(const char *file, const char *str, const char *type)
> +{
> +	char buf[BUFSIZ];
> +	int ret;
> +	int fd;
> +
> +	fd = open(file, O_WRONLY | O_TRUNC);
> +	if (fd < 0)
> +		die("opening to '%s'", file);
> +	ret = write(fd, str, strlen(str));
> +	close(fd);
> +	if (ret < 0 && type) {
> +		/* write failed */
> +		fd = open(file, O_RDONLY);
> +		if (fd < 0)
> +			die("writing to '%s'", file);
> +		/* the filter has the error */
> +		while ((ret = read(fd, buf, BUFSIZ)) > 0)
> +			fprintf(stderr, "%.*s", ret, buf);
> +		die("Failed %s of %s\n", type, file);

Yeah, the above needs to be moved to the upper layers. It even has a
comment about "the filter has the error". That's reference to the
filter file of trace events, which is the only file that really does
that.

-- Steve

> +		close(fd);
> +	}
> +	return ret;
> +}
> 
