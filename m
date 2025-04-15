Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4D92820B7;
	Tue, 15 Apr 2025 16:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744735980; cv=none; b=gUoBqssQhg1fUrQlLNW+8bF7RsDU/N6yB2MEcelKyRyxdYe/17HVbO03vib95AtR7B6Zn+NhuWvqrKH0I2qQuYVN7i+sC/fyR0Lf5BPVN8ff9fVT9DK9X8bn3Q4WMEc2iAzZX3f4S3hm/JSFbJh6mdvQXZ3wvwkQnENjOu88tmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744735980; c=relaxed/simple;
	bh=hCMknlHRTzlSIKM9RzqV7AntkkP8z3lwY8MySCL5m8A=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=k20pZLoG5vx+UXdzb5Du1rNWVzwmJ+1Ebl8z5nrjyVYPdQ8q++RdL3PplqxyOutUrvEeiPO2D0N++pAkn4xVg8YxQSQGK1U0uFmWIrHJ0m6Qc/+9cLrsU2pVaJDh03m9zLDwsX2RZWR+cnAherLSzQLc2Nzr+rFL7hzLAyHWVoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F98C4CEEE;
	Tue, 15 Apr 2025 16:52:59 +0000 (UTC)
Date: Tue, 15 Apr 2025 12:54:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, "linux-trace-users@vger.kernel.org"
 <linux-trace-users@vger.kernel.org>, Linux Trace Devel
 <linux-trace-devel@vger.kernel.org>
Subject: [ANNOUNCE] trace-cmd 3.3.2 and libtracefs 1.8.2 have been released
Message-ID: <20250415125433.2be5fcae@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

trace-cmd 3.3.2 and libtracefs 1.8.2 have been released:

 Release notes:

    trace-cmd 3.3.2: https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/tag/?h=trace-cmd-v3.3.2

    libtracefs 1.8.2: https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/tag/?h=libtracefs-1.8.2

Enjoy,

-- Steve
