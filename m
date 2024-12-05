Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6A121A457
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Dec 2024 14:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409903; cv=none; b=IkFgDv4SR3GT9HkfH5eiuPNr6axJ7S1omwK5foEpA6ctcNkicW6B5I/herkuY3SHHf08B9CI+DcIURfEc5FyMV9880IkFAO6rnwkXTCPdyKrhs1xDg6eHSfQ/sf6ED/IKuuAdE5jJNDWx5IBp7j/tEKYIEGpPei9OzRofNmg2J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409903; c=relaxed/simple;
	bh=mbzTd4y9YDx+l1EnE7cDJk8E2anvda6MgqF5xwXQ9sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rds7ZkH43BjQ6f7J0uYOSHwciDZOs6SJCzUPYXW7ffEQqgQuH575dRqftJnfDosPtA7TEryU8hEF8wBwGbMHtiJdcFOnLJqRX4IFVMpm/BVCcGoZH7OXoLw3Vmp63sfdQ4UJeaXEcucUy8A+9zuU5soOG19fFM+Qy8Ni5NfvDlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HGDS3b4D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HGDS3b4D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733409900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fySU8jnFnJGArxdAEK/S+WQ8TjVtRt5sb+mKjcLKtZQ=;
	b=HGDS3b4D/PvSaIF/Q+CFmzrFmqJfkQxBg6sDhWNE79FV0t5UnVLLNIUv9KAaVck0ggSfvV
	vT3/tGyGEWlt3NZJ9Xrzf/XrTwsOJA/kW6q0I9Dj7TC3R1SS0HvWZCFPZB7X1BCkqE7SNw
	0RWpzMSgaBBwaZ2uTs1ifouIhXkFHr4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-3tA5WZCvMW6MCFbhwQlZHw-1; Thu,
 05 Dec 2024 09:44:58 -0500
X-MC-Unique: 3tA5WZCvMW6MCFbhwQlZHw-1
X-Mimecast-MFC-AGG-ID: 3tA5WZCvMW6MCFbhwQlZHw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5EBF01954213;
	Thu,  5 Dec 2024 14:44:57 +0000 (UTC)
Received: from fedora (unknown [10.43.17.16])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 6CB431956052;
	Thu,  5 Dec 2024 14:44:55 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 05 Dec 2024 15:44:54 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 4/7] trace-cmd lib: Prevent memory leak in tracecmd_msg_wait_for_cmd()
Date: Thu,  5 Dec 2024 15:44:36 +0100
Message-ID: <20241205144439.127564-5-jmarchan@redhat.com>
In-Reply-To: <20241205144439.127564-1-jmarchan@redhat.com>
References: <20241205144439.127564-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

When tracecmd_msg_wait_for_cmd() returns successfully, msg->buf isn't
freed. Call msg_free() to free it.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-msg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index f5c604f1..c7583587 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -1034,8 +1034,10 @@ static int tracecmd_msg_wait_for_cmd(struct tracecmd_msg_handle *msg_handle, enu
 		if (ret < 0)
 			goto error;
 
-		if (ntohl(msg.hdr.cmd) == cmd)
+		if (ntohl(msg.hdr.cmd) == cmd) {
+			msg_free(&msg);
 			return 0;
+		}
 
 		error_operation(&msg);
 		ret = handle_unexpected_msg(msg_handle, &msg);
-- 
2.47.0

