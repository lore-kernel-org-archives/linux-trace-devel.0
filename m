Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A9E2E631
	for <linux-trace-devel@vger.kernel.org>; Mon, 13 May 2024 17:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715622412; cv=none; b=CPfkgWCsygPVhXfYFN7fVX7AfqQsML2AQmAN+Hzw15DPx+sXKvnFy3Vtw1Et5k4ljQ6+ZEg0bhYu+7NCxadU2ImbjxW36YPpDKU0KsFZ6zWKQsB0wndM98dN1uCXNOHnohGDUIY7JnWVA/9zaBwr82F8E9R5aAYAkuJxem+MUl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715622412; c=relaxed/simple;
	bh=yJz4qxLxwZMXT35h8tXENj+kEZdJo0RgSjVcR+lDEKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GXlFV9MeRgGuK+WDCbPH1SA2UzUMCGHG5je/P39cA3/C5t/+bpIiMbImQMAcShenmatku40lFRIX8m69nJbj9Fiv2R9+0bfhuZzCsTo23wELvM20USPm21jBiCGNeLM/NAARii3V0Nnq7hk2AmEclmoYHTOOy6apwY2DYPqUAH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N1t/qWF4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N1t/qWF4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715622409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iA9SwBsAx9uL/fCfF9esSNDjiyAL00XcjVSajlyKR2A=;
	b=N1t/qWF45ALI3ubOW4pph3ps/DG6JbR5uT2HpZ8AMZ2QC1mdVn5khWeD8sgABR0p6GC7sP
	IkwQBpxXpakbxEfNWNT6kIJxNec4E0mCAVxfoeiDypamdnvlqRVr9n1bUDx65GbRiepQXw
	W1w5zFrzF5qDe9imYsNQfju4xDk0jdg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-179-6VzdiCxlNZaJvRGQakmQrA-1; Mon,
 13 May 2024 13:46:48 -0400
X-MC-Unique: 6VzdiCxlNZaJvRGQakmQrA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E99E429AA3BF;
	Mon, 13 May 2024 17:46:47 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.8])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E2A440C6EB7;
	Mon, 13 May 2024 17:46:47 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 530C1403E2AAF; Mon, 13 May 2024 14:46:31 -0300 (-03)
Date: Mon, 13 May 2024 14:46:31 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Junyao Zhao <junzhao@redhat.com>, Nini Gu <ngu@redhat.com>,
	linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: support -m parameter for virt instances
Message-ID: <ZkJR9wJLAuEDpmR7@tpad>
References: <Zemv4OUx1WexdrlB@tpad>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zemv4OUx1WexdrlB@tpad>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2


Ping?

On Thu, Mar 07, 2024 at 09:15:28AM -0300, Marcelo Tosatti wrote:
> 
> Take into consideration the value passed in with "-m",
> the max size in kilobytes that a per cpu buffer should be,
> when reading trace data from guests.
> 
> This allows one to prevent running out of diskspace on long runs.
> 
> Reported-by: Junyao Zhao <junzhao@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index f2cf8dc8..2d14ed7a 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -370,7 +370,7 @@ enum {
>  void tracecmd_free_recorder(struct tracecmd_recorder *recorder);
>  struct tracecmd_recorder *tracecmd_create_recorder(const char *file, int cpu, unsigned flags);
>  struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned flags);
> -struct tracecmd_recorder *tracecmd_create_recorder_virt(const char *file, int cpu, unsigned flags, int trace_fd);
> +struct tracecmd_recorder *tracecmd_create_recorder_virt(const char *file, int cpu, unsigned flags, int trace_fd, int maxkb);
>  struct tracecmd_recorder *tracecmd_create_recorder_maxkb(const char *file, int cpu, unsigned flags, int maxkb);
>  struct tracecmd_recorder *tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, struct tracefs_instance *instance);
>  struct tracecmd_recorder *tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, struct tracefs_instance *instance);
> diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
> index 0633edf5..44f245d5 100644
> --- a/lib/trace-cmd/trace-recorder.c
> +++ b/lib/trace-cmd/trace-recorder.c
> @@ -175,19 +175,46 @@ tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, struct trace
>  
>  static struct tracecmd_recorder *
>  __tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
> -				  struct tracefs_instance *instance, int tfd)
> +				  struct tracefs_instance *instance, int tfd, int maxkb)
>  {
>  	struct tracecmd_recorder *recorder;
> -	int fd;
> +	int fd, fd2 = -1;
> +	char *file2;
>  
> -	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
> +	fd = open(file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
>  	if (fd < 0)
>  		return NULL;
>  
> -	recorder = create_buffer_recorder_fd2(fd, -1, cpu, flags, instance, 0, tfd);
> +	if (maxkb) {
> +		int len = strlen(file);
> +
> +		file2 = malloc(len + 3);
> +		if (!file2)
> +			return NULL;
> +
> +		sprintf(file2, "%s.1", file);
> +
> +		fd2 = open(file2, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
> +		if (fd2 < 0) {
> +			close(fd);
> +			unlink(file);
> +			free(file2);
> +			return NULL;
> +		}
> +	}
> +
> +	recorder = create_buffer_recorder_fd2(fd, fd2, cpu, flags, instance, maxkb, tfd);
>  	if (!recorder) {
>  		close(fd);
>  		unlink(file);
> +		if (fd2 != -1)
> +			close(fd2);
> +	}
> +
> +	if (fd2 != -1) {
> +		/* Unlink file2, we need to add everything to file at the end */
> +		unlink(file2);
> +		free(file2);
>  	}
>  
>  	return recorder;
> @@ -242,7 +269,7 @@ struct tracecmd_recorder *
>  tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
>  				struct tracefs_instance *instance)
>  {
> -	return __tracecmd_create_buffer_recorder(file, cpu, flags, instance, -1);
> +	return __tracecmd_create_buffer_recorder(file, cpu, flags, instance, -1, 0);
>  }
>  
>  /**
> @@ -255,9 +282,9 @@ tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
>   */
>  struct tracecmd_recorder *
>  tracecmd_create_recorder_virt(const char *file, int cpu, unsigned flags,
> -			      int trace_fd)
> +			      int trace_fd, int maxkb)
>  {
> -	return __tracecmd_create_buffer_recorder(file, cpu, flags, NULL, trace_fd);
> +	return __tracecmd_create_buffer_recorder(file, cpu, flags, NULL, trace_fd, maxkb);
>  }
>  
>  struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned flags)
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 91cc90d4..69ea0cbd 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -3584,7 +3584,7 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
>  			flags |= TRACECMD_RECORD_NOBRASS;
>  		else if (!trace_vsock_can_splice_read())
>  			flags |= TRACECMD_RECORD_NOSPLICE;
> -		return tracecmd_create_recorder_virt(file, cpu, flags, fd);
> +		return tracecmd_create_recorder_virt(file, cpu, flags, fd, max_kb);
>  	}
>  
>  	if (brass)
> 

