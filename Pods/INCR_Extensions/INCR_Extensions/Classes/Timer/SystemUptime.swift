import Foundation

public class SystemUptime {
    public class func uptime() -> TimeInterval {
        
        var boottime:timeval = timeval(tv_sec: 0, tv_usec: 0)
        var size:size_t = MemoryLayout.size(ofValue: boottime)
        
        let mibPointer = UnsafeMutablePointer<Int32>.allocate(capacity: 2)
        mibPointer[0] = CTL_KERN
        mibPointer[1] = KERN_BOOTTIME
        
        var now:timeval = timeval(tv_sec: 0, tv_usec: 0)
        var tz:timezone = timezone(tz_minuteswest: 0, tz_dsttime: 0)
        gettimeofday(&now, &tz)
                
        if sysctl(mibPointer, 2, &boottime, &size, nil, 0) != -1 && boottime.tv_sec != 0 {
            var uptimeL = (now.tv_sec - boottime.tv_sec)*1000
            uptimeL += Int((now.tv_usec - boottime.tv_usec)/1000)
            return TimeInterval(uptimeL)/1000.0
        }

        return 0
    }
}
