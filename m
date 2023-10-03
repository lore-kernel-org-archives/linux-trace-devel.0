Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4262770F
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Oct 2023 13:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BCDC433C9;
	Tue,  3 Oct 2023 13:46:59 +0000 (UTC)
Date: Tue, 3 Oct 2023 09:48:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ross Zwisler <zwisler@google.com>
Cc: linux-trace-devel@vger.kernel.org, Stevie Alvarez
 <stevie.6strings@gmail.com>
Subject: Re: [PATCH 0/2] libtraceeval: Remove the need of
 TRACEEVAL_TYPE_NONE
Message-ID: <20231003094804.77078cb6@gandalf.local.home>
In-Reply-To: <20231002211826.GO1532181@google.com>
References: <20230929100025.1018258-1-rostedt@goodmis.org>
	<20231002210749.GN1532181@google.com>
	<20231002211826.GO1532181@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 2 Oct 2023 15:18:26 -0600
Ross Zwisler <zwisler@google.com> wrote:

> > Looks good, you can add:
> > Reviewed-by: Ross Zwisler <zwisler@google.com>  
> 
> Actually, I think we need to make similar updates in check_keys() and
> check_vals(), else calls to traceeval_init_data_size() will walk off the end
> of those respective arrays.

Good catch! I'm surprised this didn't crash it my testing. Maybe it as just
aligned in a way that there was a NULL after it.

-- Steve
