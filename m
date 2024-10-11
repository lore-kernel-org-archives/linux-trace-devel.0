Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE4638DF9
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Oct 2024 18:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728671263; cv=none; b=CvAQghsWKhl1ofG5YhxTqWeDOk92w0s0d0FVzOpsku0+Tu0gkBOQSjyDwn8JMY/R0vimydqGPHjANRI3KR2qCer+1iyvSaZtIBR3eArFu9SMTamtVP9Pi5H8QT4j+l8xkXZhSBsA6aD6acAkkk+IUQvSx5GmIoDXkPPbKDdvgN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728671263; c=relaxed/simple;
	bh=MumL5CjePXnP4e3sh12y2J0K4T10Y1arFCLQPwhDf3s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BN/xIVcTc4wh3o+OAQDuuKYXn2cElj/0SxPDerhRfv6E/3jFuBwBGwF4q3Swc2/hXPihMBBqD1OsWeQj9cGdr5eSs2Q6wLGq7wgtIaPSkJSixSUyul1/tJsKclk6qSCKTQw9Wk89MjKGw0Z16KwGxckIqfQ0HwhlZnzjf0AxlgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C195C4CEC3;
	Fri, 11 Oct 2024 18:27:43 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1szKMj-00000001V18-2LB6;
	Fri, 11 Oct 2024 14:27:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/4] trace-cmd: Various updates
Date: Fri, 11 Oct 2024 14:26:50 -0400
Message-ID: <20241011182752.357499-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Various trace-cmd updates:

- Add a way to show "max_latency"

- Use tracefs_instances() helper function

- Use tracefs_filter_functions() helper function

Steven Rostedt (VMware) (4):
  trace-cmd list: Use tracefs_filter_functions()
  trace-cmd show: Add --max_latency
  trace-cmd list: Use tracefs_instances() to list instances
  trace-cmd stat: Use tracefs_instances() instead of walking them

 tracecmd/trace-list.c  | 54 ++++++++++++++++--------------------------
 tracecmd/trace-show.c  |  6 +++++
 tracecmd/trace-stat.c  | 26 ++++++++++----------
 tracecmd/trace-usage.c |  1 +
 4 files changed, 41 insertions(+), 46 deletions(-)

-- 
2.45.2

