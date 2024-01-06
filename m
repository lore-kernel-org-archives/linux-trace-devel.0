Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D666A6FC8
	for <linux-trace-devel@vger.kernel.org>; Sat,  6 Jan 2024 13:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB156C433C7;
	Sat,  6 Jan 2024 13:08:43 +0000 (UTC)
Date: Sat, 6 Jan 2024 08:08:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v2] libtracefs: Add ring buffer memory mapping APIs
Message-ID: <20240106080841.2eb16bd7@rorschach.local.home>
In-Reply-To: <20240105152906.743d7e03@gandalf.local.home>
References: <20240105152906.743d7e03@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 5 Jan 2024 15:29:06 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Add the following APIs:
> 
>  tracefs_cpu_open_mapped()
>  tracefs_cpu_is_mapped()
>  tracefs_cpu_map()
>  tracefs_cpu_unmap()
> 
> This will allow applications to choose to memory map the tracing ring buffer
> if it is supported. This will improve the performance of tracefs_cpu_read()
> and tracefs_cpu_read_buf(), but it is not done by default because it will
> also hurt the performance of tracefs_cpu_buffered_read() and
> tracefs_cpu_buffered_read_buf() as those use splicing, and with the ring
> buffer memory mapped, the splice has to do a copy instead of a copyless
> subbuffer move.
> 
> Since this change relies on the libtraceevent APIs:
> 
>    kbuffer_dup()
>    kbuffer_subbuffer()
>    kbuffer_refresh()
>    kbuffer_read_buffer()
> 
> Which are available after version 1.8, up the minimum version to 1.8.
> 
> Note, the samples and utest rely on:
> 
>    tep_get_sub_buffer_data_size()
> 
> which is in 1.8.1.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> Changes since v1: https://lore.kernel.org/linux-trace-devel/20231228201100.78aae259@rorschach.local.home

Updated the subject to say this is v2 :-p

-- Steve
