Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24274137C23
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 00:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969140; cv=none; b=rnJkVEnr8gOtNND/HUaM5dh+eNbX33ePZF0invuhVTIohe9wITbWCDRRS0edmIosQ6TkxCjIIHONLm1C8xP4nKZIu6ZslUU4AXrJxp33hMxZ3iit2on1Zu+TkrROXyRWohRimLCxN8NudhKTaSyhXgjyMNuQHX4sr2yjKpgjdlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969140; c=relaxed/simple;
	bh=GGLmQsrpmCYU7oI+Q/3jIOerTUIhv9my1NV0e0iUixs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pq8r1EhX4yv3VXyvzx1ZyuIfznlDZbBonGfIF3VnvoRLv1cHmC30nqpxz2yWksXIgJkHe73oQqJIW/RFQCyERMhJH3fJkK2MmiZBgwVPNu4eRork0Uz0jsOui4d+1o3HElVxL3JGMeI8562BsJFBXrm1Frit5XfHz/3r1iiKccs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D97C433C7;
	Tue, 23 Jan 2024 00:18:59 +0000 (UTC)
Date: Mon, 22 Jan 2024 19:20:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 4/7] trace-cmd split: Add functions to generate temp
 files
Message-ID: <20240122192028.69e79570@gandalf.local.home>
In-Reply-To: <20240122164336.167256-5-pierre.gondois@arm.com>
References: <20240122164336.167256-1-pierre.gondois@arm.com>
	<20240122164336.167256-5-pierre.gondois@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Jan 2024 17:43:33 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

> To prepare handling of multiple instances and storing them
> in temporary files, add utility functions generating file names,
> removing files, creating files:
> - get_temp_file()
> - delete_temp_file()
> - put_temp_file()
> - touch_file()
> 
> Also make use these functions.
> 
> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
> ---
>  tracecmd/trace-split.c | 70 +++++++++++++++++++++++++++++++++---------
>  1 file changed, 55 insertions(+), 15 deletions(-)
> 
> diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
> index f46813d1..5f3ed940 100644
> --- a/tracecmd/trace-split.c
> +++ b/tracecmd/trace-split.c
> @@ -392,6 +392,52 @@ static int parse_cpu(struct tracecmd_input *handle,
>  	return 0;
>  }
>  
> +static char *get_temp_file(const char *output_file, const char *name, int cpu)
> +{
> +	const char *dot;
> +	char *file = NULL;
> +	char *output;
> +	char *base;
> +	char *dir;
> +	int ret;
> +
> +	if (name)
> +		dot = ".";
> +	else
> +		dot = name = "";
> +
> +	output = strdup(output_file);

Nit on strdup() error checking again.

I know that I have forgotten to do this too, but lets not add more ;-)
and lets add the checks if they were missing when we modify that code.

Doing a clean up on that is on my todo list.

-- Steve


> +	/* Extract basename() first, as dirname() truncates output */
> +	base = basename(output);
> +	dir = dirname(output);
> +
> +	ret = asprintf(&file, "%s/.tmp.%s.%s%s%d", dir, base, name, dot, cpu);
> +	if (ret < 0)
> +		die("Failed to allocate file for %s %s %s %d", dir, base, name, cpu);
> +	free(output);
> +	return file;
> +}
