Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F3B18EA82
	for <linux-trace-devel@vger.kernel.org>; Mon, 15 Jul 2024 15:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721056373; cv=none; b=paeF5ZoZTkyskDAIG6GWQlRt2xyRH2B6FmnwptZqnHsG4pSYhJTeVwTvoJnzjqJzEDIDkC65uX/aW49EipX0zA6QPY6g/oagc5rbqHSwvPUMRPvNHpLuMo+gqM/BofqEDKjQn4RmAzcv5SDmBApVMDucPRIOA9U+yGBnueoyF8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721056373; c=relaxed/simple;
	bh=hE7hUY7+Gn6Jd0eApOtjrrxXRkTgg2MXDrQTXkflB+8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lpTubSmTHWpepSAR4ZBXq7kwTZ/HKhBTxBpSRSfCoEpmaMLVxfEzoBcyeLHKtjvK+Mz2pYo/2UFx6ql8Kq9WIk6aJNtVZcCfaAIgecxcE4GEyiM1CArsnCArLf5V25fO2bOgmCRrXPRHqFstvhGb9U6ahXxpo/kB+KNB75P6kLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DFDC32782;
	Mon, 15 Jul 2024 15:12:52 +0000 (UTC)
Date: Mon, 15 Jul 2024 11:12:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Schmidt, Adriaan" <adriaan.schmidt@siemens.com>
Cc: Tejun Heo <tj@kernel.org>, "linux-trace-devel@vger.kernel.org"
 <linux-trace-devel@vger.kernel.org>, Johannes Berg
 <johannes@sipsolutions.net>, "yselkowi@redhat.com" <yselkowi@redhat.com>
Subject: Re: [PATCH] trace-cmd: python: Update python module
Message-ID: <20240715111250.2b2ba512@rorschach.local.home>
In-Reply-To: <AS4PR10MB5318B6DCD04F15271B9360DCEDA12@AS4PR10MB5318.EURPRD10.PROD.OUTLOOK.COM>
References: <Y+w51nOhNd+PGo/k@slm.duckdns.org>
	<20230214205354.51f119c3@rorschach.local.home>
	<AS4PR10MB5318B6DCD04F15271B9360DCEDA12@AS4PR10MB5318.EURPRD10.PROD.OUTLOOK.COM>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jul 2024 12:11:57 +0000
"Schmidt, Adriaan" <adriaan.schmidt@siemens.com> wrote:

> Hi,
> 
> Bumping this old-but-still-relevant patch...
> There is a related item on Bugzilla [1], and there was also a more
> recent proposal to touch the python bindings [2], and I believe the
> issue addressed there (use old Python API) would also be fixed by
> this patch.
> 

Thanks for the bump. I'll try to get some time to get to it in the
following weeks.

-- Steve

> Thanks,
> Adriaan
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=217104
> [2] https://lore.kernel.org/all/20240623171109.691772-1-yselkowi@redhat.com/
> 
